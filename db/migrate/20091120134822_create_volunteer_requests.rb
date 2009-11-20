class CreateVolunteerRequests < ActiveRecord::Migration
  def self.up
    create_table :volunteer_requests do |t|
      t.integer :user_id
      t.string  :reason, :limit => 4096
      t.datetime :approved_at
      t.integer :approver_id
      t.timestamps
    end

    add_index :volunteer_requests, :user_id
  end

  def self.down
    drop_table :volunteer_requests
  end
end
