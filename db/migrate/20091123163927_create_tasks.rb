class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.integer   :creator_id
      t.integer   :editor_id
      t.integer   :assignee_id
      t.string    :name
      t.string    :state, :limit => 16
      t.string    :kind
      t.string    :difficulty, :limit => 16
      t.boolean   :full_nikkud, :default => false
      t.integer   :parent_id
      t.integer   :child_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
