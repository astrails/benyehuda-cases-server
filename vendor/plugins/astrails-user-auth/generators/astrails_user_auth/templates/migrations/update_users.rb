class AuthUpdateUsers < ActiveRecord::Migration
  def self.up
<%
      existing_columns = ActiveRecord::Base.connection.columns(:users).collect { |each| each.name }
      columns = [
        [:name,               "t.string   :name, :limit => 48"],
        [:email,              "t.string   :email, :null => false, :limit => 100"],
        [:crypted_password,   "t.string   :crypted_password, :null => true, :limit => 128"],
        [:password_salt,      "t.string   :password_salt, :null => true, :limit => 20"],
        [:persistence_token,  "t.string   :persistence_token, :limit => 128"],
        [:single_access_token,"t.string   :single_access_token, :limit => 20"],
        [:perishable_token,   "t.string   :perishable_token, :limit =>  20"],
        [:login_count,        "t.integer  :login_count"],
        [:current_login_at,   "t.datetime :current_login_at"],
        [:last_login_at,      "t.datetime :last_login_at"],
        [:activated_at,       "t.datetime :activated_at"],
        [:current_login_ip,   "t.string   :current_login_ip, :limit => 15"],
        [:last_login_ip,      "t.string   :last_login_ip, :limit => 15"],
        [:is_admin,           "t.boolean  :is_admin"],
        [:pending,            "t.boolean  :pending"],
      ].delete_if {|c| existing_columns.include?(c.first.to_s)}
-%>
    change_table(:users) do |t|
<% columns.each do |c| -%>
      <%= c.last %>
<% end -%>
    end

<%
    existing_indexes = ActiveRecord::Base.connection.indexes(:users)
    index_names = existing_indexes.collect { |each| each.name }
    new_indexes = [
      [:index_users_on_email,               'add_index :users, :email'],
      [:index_users_on_persistence_token,   'add_index :users, :persistence_token'],
      [:index_users_on_perishable_token,    'add_index :users, :perishable_token'],
      [:index_users_on_single_access_token, 'add_index :users, :single_access_token'],
    ].delete_if { |each| index_names.include?(each.first.to_s) }
-%>
<% new_indexes.each do |each| -%>
    <%= each.last %>
<% end -%>
  end

  def self.down
    change_table(:users) do |t|
<% unless columns.empty? -%>
      t.remove <%= columns.collect { |each| ":#{each.first}" }.join(',') %>
<% end -%>
    end
  end
end
