# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091211152047) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.string   "message",    :limit => 4096
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["task_id", "created_at"], :name => "task_created"

  create_table "custom_properties", :force => true do |t|
    t.integer  "property_id"
    t.integer  "proprietary_id"
    t.string   "proprietary_type", :limit => 32
    t.string   "custom_value",     :limit => 8192
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "custom_properties", ["proprietary_id", "proprietary_type"], :name => "proprietary"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "global_preferences", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "ttl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "global_preferences", ["name"], :name => "index_global_preferences_on_name", :unique => true

  create_table "properties", :force => true do |t|
    t.string   "title"
    t.string   "parent_type",   :limit => 32
    t.string   "property_type", :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "editor_id"
    t.integer  "assignee_id"
    t.string   "name"
    t.string   "state",       :limit => 16
    t.string   "kind"
    t.string   "difficulty",  :limit => 16
    t.boolean  "full_nikkud",               :default => false
    t.integer  "parent_id"
    t.integer  "child_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                :limit => 48
    t.string   "email",               :limit => 100,                    :null => false
    t.string   "crypted_password",    :limit => 128
    t.string   "password_salt",       :limit => 20
    t.string   "persistence_token",   :limit => 128
    t.string   "single_access_token", :limit => 20
    t.string   "perishable_token",    :limit => 20
    t.integer  "login_count"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "activated_at"
    t.string   "current_login_ip",    :limit => 15
    t.string   "last_login_ip",       :limit => 15
    t.boolean  "is_admin"
    t.boolean  "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_volunteer",                       :default => false
    t.boolean  "is_editor",                          :default => false
    t.datetime "disabled_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["single_access_token"], :name => "index_users_on_single_access_token"

  create_table "volunteer_requests", :force => true do |t|
    t.integer  "user_id"
    t.string   "reason",      :limit => 4096
    t.datetime "approved_at"
    t.integer  "approver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "volunteer_requests", ["user_id"], :name => "index_volunteer_requests_on_user_id"

end
