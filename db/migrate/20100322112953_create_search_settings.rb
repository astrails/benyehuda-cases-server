class CreateSearchSettings < ActiveRecord::Migration
  def self.up
    create_table :search_settings do |t|
      t.integer :user_id
      t.string  :search_key
      t.string  :search_value
      t.timestamps
    end

    add_index :search_settings, [:user_id, :search_key]
  end

  def self.down
    drop_table :search_settings
  end
end
