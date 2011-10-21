module Flogiston::Zoning
  def self.extended(b)
    b.belongs_to :site
  end
end
