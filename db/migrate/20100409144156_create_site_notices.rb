class CreateSiteNotices < ActiveRecord::Migration
  def self.up
    create_table :site_notices do |t|
      t.datetime    :start_displaying_at
      t.datetime    :end_displaying_at
      t.string      :html, :limit => 8192
      t.timestamps
    end

    add_index :site_notices, [:start_displaying_at, :end_displaying_at]
  end

  def self.down
    drop_table :site_notices
  end
end
