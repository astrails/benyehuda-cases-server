class VolunteerRequests < ActiveRecord::Migration
  def self.up
    rename_column :volunteer_requests, :reason, :preferences
  end

  def self.down
    rename_column :volunteer_requests, :preferences, :reason
  end
end
