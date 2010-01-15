class AddActivationEmailSentAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_email_sent_at, :datetime
    ActiveRecord::Base.connection.execute "update users set activation_email_sent_at = '2009-12-31'"
  end

  def self.down
    remove_column :users, :activation_email_sent_at
  end
end
