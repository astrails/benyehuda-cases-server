class CreateCustomProperties < ActiveRecord::Migration
  def self.up
    create_table :custom_properties do |t|
      t.column :property_id, :integer
      t.column :proprietary_id, :integer
      t.column :proprietary_type, :string, :limit => 32
      t.column :custom_value, :string, :limit => 8192
      t.timestamps
    end

    add_index :custom_properties, [:proprietary_id, :proprietary_type], :name => "proprietary"
  end

  def self.down
    drop_table :custom_properties
  end
end
