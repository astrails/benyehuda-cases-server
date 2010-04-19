class CreateAssignmentHistories < ActiveRecord::Migration
  class Task < ActiveRecord::Base
    has_many :assignment_histories, :dependent => :destroy
  end

  def self.up
    create_table :assignment_histories do |t|
      t.integer :user_id
      t.integer :task_id
      t.string  :role, :limit => 16
      t.timestamps
    end
    
    add_index :assignment_histories, :user_id

    Task.all.each do |t|
      t.assignment_histories.create(:user_id => t.creator_id, :role => "creator", :created_at => t.created_at) if t.creator_id
      t.assignment_histories.create(:user_id => t.assignee_id, :role => "assignee", :created_at => t.created_at) if t.assignee_id
      t.assignment_histories.create(:user_id => t.editor_id, :role => "editor", :created_at => t.created_at) if t.editor_id
    end
  end

  def self.down
    drop_table :assignment_histories
  end
end
