class UpgradeTranslationTexts < ActiveRecord::Migration
  def self.up
    say "SORRY it's one-way only!"
    TranslationText.all.each do |tt|
      tt.update_attributes! :text => tt.text.gsub(/\{\{([a-z0-9_]*)\}\}/, '%{\\1}')
    end
  end

  def self.down
    say "I said SORRY it was one-way only!!!"
    raise
  end
end
