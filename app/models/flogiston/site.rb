class Flogiston::Site < ActiveRecord::Base
  has_many :domains

  validates_presence_of   :name
  validates_presence_of   :handle
  validates_uniqueness_of :name
  validates_uniqueness_of :handle

  def self.for_domain(name)
    return nil unless domain = Domain.find_by_name(name)
    domain.site
  end
end
