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
    end
  end
end
