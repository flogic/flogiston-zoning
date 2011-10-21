class Flogiston::Site < ActiveRecord::Base
  validates_presence_of   :name
  validates_presence_of   :handle
  validates_uniqueness_of :name
  validates_uniqueness_of :handle
end
