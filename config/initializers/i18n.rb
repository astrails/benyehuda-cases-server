require "fast_gettext/translation_repository/db"
FastGettext::TranslationRepository::Db.require_models

class SmartTranslationKey < TranslationKey
  # mostly kopypasta from fast_gettext-0.6.4/lib/fast_gettext/translation_repository/db_models/translation_key.rb
  def self.translation(key, locale)
    translation_key = find_or_create_by_key(key)
    return unless translation_text = translation_key.translations.find_by_locale(locale)
    translation_text.text
  end
end

FastGettext.add_text_domain 'app', :type => :db, :model => SmartTranslationKey

FastGettext.default_text_domain = 'app'
FastGettext.locale = 'he'
AVAILABLE_LOCALES = FastGettext.available_locales = ['en', 'he', 'ru']
