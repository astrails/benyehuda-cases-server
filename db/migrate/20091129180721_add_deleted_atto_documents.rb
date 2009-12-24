class AddDeletedAttoDocuments < ActiveRecord::Migration
  def self.up
    add_column :documents, :deleted_at, :datetime
  end

  def self.down
    remove_column :documents, :deleted_at
  end
end
