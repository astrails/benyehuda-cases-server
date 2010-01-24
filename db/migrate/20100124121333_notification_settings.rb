class NotificationSettings < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_on_comments, :boolean, :default => true
    add_column :users, :notify_on_status, :boolean, :default => true
  end

  def self.down
    remove_column :users, :notify_on_comments
    remove_column :users, :notify_on_status
  end
end
