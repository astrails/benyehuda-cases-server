require 'active_record'
module FastGettext
  module TranslationRepository
    # Responsibility:
    #  - provide access to translations in database through a database abstraction
    #
    #  Options:
    #   :model => Model that represents your keys
    #   you can either use the models supplied under db/, extend them or build your own
    #   only constraints:
    #     key: find_by_key, translations
    #     translation: text, locale
    class Db
      def initialize(name,options={})
        @model = options[:model]
      end

      def available_locales
        if @model.respond_to? :available_locales
          @model.available_locales || []
        else
          []
        end
      end

      def pluralisation_rule
        if @model.respond_to? :pluralsation_rule
          @model.pluralsation_rule
        else
          nil
        end
      end

      def [](key)
        @model.translation(key, FastGettext.locale)
      end

      def plural(*args)
        @model.translation(args, FastGettext.locale) || []
      end

      def self.require_models
        require 'fast_gettext/translation_repository/db_models/translation_key'
        require 'fast_gettext/translation_repository/db_models/translation_text'
        FastGettext::TranslationRepository::DbModels
      end
    end
  end
end