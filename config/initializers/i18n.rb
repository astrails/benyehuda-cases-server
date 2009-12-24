AVAILABLE_LOCALES = ['en','he', 'ru']

include FastGettext::TranslationRepository::Db.require_models
TranslationKey.class_eval {attr_accessible :key}
TranslationText.class_eval {attr_accessible :text, :locale}
FastGettext.add_text_domain 'app', :type => :db, :model => TranslationKey
FastGettext.default_text_domain = 'app'
FastGettext.available_locales = AVAILABLE_LOCALES
