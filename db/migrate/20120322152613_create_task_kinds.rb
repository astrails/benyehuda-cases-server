class CreateTaskKinds < ActiveRecord::Migration
  def self.up
    remove_column :tasks, :kind
    add_column :tasks, :task_kind_id, :integer

    create_table :task_kinds do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :task_kinds
    remove_column :tasks, :task_kind_id
    add_column :tasks, :kind, :string
  end
end
