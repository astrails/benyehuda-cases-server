class AddAuditsTable < ActiveRecord::Migration
  def self.up
    create_table :audits, :force => true do |t|
      t.integer  "auditable_id"
      t.string   "auditable_type"
      t.integer  "user_id"
      t.integer  "action"
      t.text     "note"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "task_id"
      t.text     "changes"
      t.boolean  "hidden", :default => false
    end

    add_index :audits, :task_id
  end

  def self.down
    drop_table :audits
  end
end
