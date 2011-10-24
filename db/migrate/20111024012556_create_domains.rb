class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains, :force => true do |t|
      t.string :name
      t.integer :site_id
      t.timestamps
    end
  end

  def self.down
    drop_table :domains
  end
end
