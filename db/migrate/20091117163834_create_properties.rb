class CreateProperties < ActiveRecord::Migration
  def self.up
    create_table :properties do |t|
      t.column :title, :string
      t.column :parent_type, :string, :limit => 32
      t.column :property_type, :string, :limit => 32
      t.timestamps
    end
  end

  def self.down
    drop_table :properties
  end
end
