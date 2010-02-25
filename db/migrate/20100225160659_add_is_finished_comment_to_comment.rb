class AddIsFinishedCommentToComment < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_finished_reason, :boolean
  end

  def self.down
    remove_column :comments, :is_finished_reason
  end
end
