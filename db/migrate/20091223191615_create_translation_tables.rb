class CreateTranslationTables < ActiveRecord::Migration
  def self.up
    create_table :translation_keys do |t|
      t.column :key, "varchar(1024) binary", :null => false
      t.timestamps
    end
    add_index :translation_keys, :key

    create_table :translation_texts do |t|
      t.text :text
      t.string :locale, :limit => 16
      t.references :translation_key, :null => false
      t.timestamps
    end
    add_index :translation_texts, [:translation_key_id, :locale], :unique => true
  end

  def self.down
    drop_table :translation_keys
    drop_table :translation_texts
  end
end
