class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer   :user_id
      t.integer   :task_id
      t.string    :message, :limit => 4096
      t.timestamps
    end

    add_index :comments, [:task_id, :created_at], :name => "task_created"
  end

  def self.down
    drop_table :comments
  end
end
