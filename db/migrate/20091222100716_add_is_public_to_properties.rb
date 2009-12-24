class AddIsPublicToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :is_public, :boolean, :default => true
  end

  def self.down
    remove_column :properties, :is_public
  end
end
