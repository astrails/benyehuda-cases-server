require 'config/initializers/i18n'

class CreateTaskKinds < ActiveRecord::Migration
  KINDS = {  # deleted from app/models/task.rb
    "typing" => _("task kind|typing"),
    "proofing" => _("task kind|proofing"),
    "other" => _("task kind|other")
  }
  def self.up
    create_table :task_kinds do |t|
      t.string :name
      t.timestamps
    end
    KINDS.each do |k,v|
      TaskKind.create!(:name => v)
    end
    rename_column :tasks, :kind, :old_kind
    add_column :tasks, :kind_id, :integer
    Task.all.each do |t|
      t.update_attributes! :kind_id => TaskKind.find_or_create_by_name(KINDS[t.old_kind] || t.old_kind).id unless t.old_kind.blank?
    end
    remove_column :tasks, :old_kind
  end
  # NOTE the code must be updated appropriately (app/models/task.rb), not possible to migrate/rollback back and forth with the same code
  def self.down
    add_column :tasks, :kind, :string
    sdnik = KINDS.invert
    Task.all.each do |t|
      k = TaskKind.find(t.kind_id).name
      t.update_attributes! :kind => sdnik[k] || k unless t.kind_id.blank?
    end
    remove_column :tasks, :kind_id
    drop_table :task_kinds
  end
end
