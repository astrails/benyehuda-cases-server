class TranslationsFormatRevert < ActiveRecord::Migration
  def self.enkode(s)
    j = s.split(FastGettext::TranslationRepository::Db.seperator)
    raise if j.length == 0
    j = j[0] if j.length == 1
    j.to_json
  end
  def self.dekode(j)
    s = ActiveSupport::JSON.decode("[#{j}]")[0]
    case s
    when String then s
    when Array then s.join(FastGettext::TranslationRepository::Db.seperator)
    else raise
    end
  end

  def self.up
    TranslationKey.all.each do |tk|
      tk.update_attributes! :key => dekode(tk.key) rescue raise "#{tk.inspect} is invalid"
    end
    TranslationText.all.each do |tt|
      tt.update_attributes! :text => dekode(tt.text) rescue raise "#{tt.inspect} is invalid"
    end
  end

  def self.down
    TranslationKey.all.each do |tk|
      tk.update_attributes! :key => enkode(tk.key) rescue raise "#{tk.inspect} is invalid"
    end
    TranslationText.all.each do |tt|
      tt.update_attributes! :text => enkode(tt.text) rescue raise "#{tt.inspect} is invalid"
    end
  end
end
