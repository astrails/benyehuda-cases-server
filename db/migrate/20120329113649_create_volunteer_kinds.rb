class CreateVolunteerKinds < ActiveRecord::Migration
  def self.up
    create_table :volunteer_kinds do |t|
      t.string :name, :limit => 64
      t.timestamps
    end
  end

  def self.down
    drop_table :volunteer_kinds
  end
end
