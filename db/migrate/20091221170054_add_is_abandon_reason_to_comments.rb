class AddIsAbandonReasonToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :is_abandoning_reason, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :is_abandoning_reason
  end
end
