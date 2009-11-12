class CreateGlobalPreferences < ActiveRecord::Migration
  class GlobalPreference < ActiveRecord::Base;
    attr_accessible :name, :value, :ttl
  end
  def self.up
    create_table :global_preferences do |t|
      t.string :name
      t.string :value
      t.integer :ttl

      t.timestamps
    end

    add_index :global_preferences, [:name], :unique => true
  end

  def self.down
    drop_table :global_preferences
  end
end
