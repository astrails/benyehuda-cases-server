class CreateVolunteerKinds < ActiveRecord::Migration
  def self.up
    create_table :volunteer_kinds do |t|
      t.string :name, :limit => 64
      t.timestamps
    end
    add_column :users, :volunteer_kind_id, :integer
  end

  def self.down
    remove_column :users, :volunteer_kind_id
    drop_table :volunteer_kinds
  end
end
