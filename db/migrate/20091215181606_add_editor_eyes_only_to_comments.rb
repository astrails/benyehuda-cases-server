class AddEditorEyesOnlyToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :editor_eyes_only, :boolean, :default => false
    remove_index :comments, :name => "task_created"
    add_index :comments, [:task_id, :created_at, :editor_eyes_only], :name => "task_created_eyes"
  end

  def self.down
    remove_index :comments, :name => "task_created_eyes"
    remove_column :comments, :editor_eyes_only
    add_index :comments, [:task_id, :created_at], :name => "task_created"
  end
end
