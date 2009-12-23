class CreateTranslationTables < ActiveRecord::Migration
  def self.up
    create_table :translation_keys do |t|
      t.string :key, :null => false
      t.timestamps
      t.index :key, :unique => true
    end

    create_table :translation_texts do |t|
      t.text :text
      t.string :locale, :limit => 16
      t.references :translation_key, :null => false
      t.index [:translation_key_id, :locale]
      t.timestamps
    end
  end

  def self.down
    drop_table :translation_keys
    drop_table :translation_texts
  end
end
