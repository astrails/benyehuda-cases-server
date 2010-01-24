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

      def plural(*msgids)
        translations = @model.translation(msgids, FastGettext.locale) || []
        return translations unless translations.blank? || translations.all?(&:blank?)
        msgids.map{|msgid| self[msgid] || msgid} #try to translate each id
      end

      def self.require_models
        require 'fast_gettext/translation_repository/db_models/translation_key'
        require 'fast_gettext/translation_repository/db_models/translation_text'
        FastGettext::TranslationRepository::DbModels
      end

      def self.decode_value(value)
        return unless value
        value = ActiveSupport::JSON.decode(value)
        return if value.blank?

        # replace "" with nil
        value.is_a?(Array) ? value.map {|v| v.blank? ? nil : v} : value
      end

      def self.preload
        require_models

        bm = Benchmark.measure do

          FastGettext.available_locales.each do |locale|
            FastGettext.caches["app"][locale] ||= {}
          end

          DbModels::TranslationKey.all(:include => :translations).each do |translation_key|
            key = translation_key.key_value
            translation_key.translations.each do |translation_text|
              value = translation_text.text_value
              FastGettext.caches[FastGettext.text_domain][translation_text.locale][key] = value || false
            end
            missing = FastGettext.available_locales - translation_key.translations.map(&:locale)
            missing.each do |locale|
              FastGettext.caches[FastGettext.text_domain][locale][key] = false
            end
          end
        end
        logger.info "Preloaded translations: %0.3f sec" % bm.real
      end

    end
  end
end