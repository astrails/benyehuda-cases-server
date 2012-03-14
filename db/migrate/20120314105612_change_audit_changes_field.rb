class ChangeAuditChangesField < ActiveRecord::Migration
  def self.up
    rename_column :audits, :changes, :changed_attrs
  end

  def self.down
    rename_column :audits, :changed_attrs, :changes
  end
end
