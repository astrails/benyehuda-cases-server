class AddCommentsToProperty < ActiveRecord::Migration
  def self.up
    add_column :properties, :comment, :string
  end

  def self.down
    remove_column :properties, :comment
  end
end
