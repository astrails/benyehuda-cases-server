class AddIsRejectionReasonToCommnets < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_rejection_reason, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :is_rejection_reason
  end
end
