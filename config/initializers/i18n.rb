require "fast_gettext/translation_repository/db"
FastGettext::TranslationRepository::Db.require_models

FastGettext.add_text_domain 'app', :type => :db, :model => TranslationKey

FastGettext.default_text_domain = 'app'
FastGettext.locale = 'he'
AVAILABLE_LOCALES = FastGettext.available_locales = ['en', 'he', 'ru']
