module Flogiston::Zoning
  def self.extended(b)
    b.send(:class_eval) do
      belongs_to :site

      #####
      # adapted from
      # http://casperfabricius.com/site/2008/12/06/removing-rails-validations-with-metaprogramming/
      removed = false
      klass   = self
      until (removed or klass == ActiveRecord::Base)
        callbacks = klass.instance_variable_get('@validate_callbacks') || []
        callbacks.reject! do |callback|
          proc = callback.method
          if proc.is_a?(Proc)
            method = eval("caller[0] =~ /`([^']*)'/ and $1", proc.binding).to_sym rescue nil # Returns the name of method the proc was declared in
            if :validates_uniqueness_of == method
              removed = true
            end
          else
            false
          end
        end
        klass = klass.superclass
      end
      #####
      validates_uniqueness_of :handle, :scope => :site_id

      def initialize_with_site_id(attributes = nil)
        if ActiveRecord::Base.current_site
          attributes ||= {}
          [:site, :site_id].each { |attr|  attributes.delete(attr) }
          attributes[:site_id] = ActiveRecord::Base.current_site.id
        end
        initialize_without_site_id(attributes)
      end
      alias_method_chain :initialize, :site_id

      scope_hash = Hash.new { |_,k|  ActiveRecord::Base.current_site && k == :conditions ? { :site_id => ActiveRecord::Base.current_site.id } : nil }
      default_scope scope_hash
    end
  end

  module Controller
    def self.extended(b)
      b.send(:class_eval) do
        before_filter :fail_unless_current_site_is_known

        def current_site
          @current_site ||= Site.for_domain(request.host)
        end
        helper_method :current_site


        private

        def fail_unless_current_site_is_known
          raise ActiveRecord::RecordNotFound unless current_site
        end
      end
    end
  end
end

ApplicationController.extend Flogiston::Zoning::Controller
