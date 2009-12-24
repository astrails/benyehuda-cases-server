class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      t.integer :user_id
      t.integer :task_id
      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
