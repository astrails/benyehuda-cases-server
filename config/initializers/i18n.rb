#require "fast_gettext"
require "fast_gettext/translation_repository/db"
include FastGettext::TranslationRepository::Db.require_models
FastGettext.add_text_domain 'app', :type => :db, :model => TranslationKey

FastGettext.default_text_domain = 'app'
FastGettext.locale = 'en'
AVAILABLE_LOCALES = FastGettext.available_locales = ['en', 'he', 'ru']
