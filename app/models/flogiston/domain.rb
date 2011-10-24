class Flogiston::Domain < ActiveRecord::Base
  belongs_to :site
  validates_presence_of :site

  validates_presence_of   :name
  validates_uniqueness_of :name
end
