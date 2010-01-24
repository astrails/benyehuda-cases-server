class RemoveChildIdFromTasks < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :child_id
  end

  def self.down
    add_column :tasks, :child_id, :integer
  end
end
