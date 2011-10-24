class AddSiteIdToOtherFlogistonTables < ActiveRecord::Migration
  def self.up
    add_column :pages,  :site_id, :integer
    add_column :assets, :site_id, :integer
  end

  def self.down
    remove_column :pages,  :site_id
    remove_column :assets, :site_id
  end
end
