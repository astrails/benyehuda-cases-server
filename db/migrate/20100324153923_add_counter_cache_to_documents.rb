class AddCounterCacheToDocuments < ActiveRecord::Migration
  def self.up
    add_column :tasks, :documents_count, :integer, :default => 0
    ActiveRecord::Base.connection.execute "update tasks set documents_count = (select count(*) from documents where task_id = tasks.id and documents.deleted_at IS NULL);"
  end

  def self.down
    remove_column :tasks, :documents_count
  end
end
