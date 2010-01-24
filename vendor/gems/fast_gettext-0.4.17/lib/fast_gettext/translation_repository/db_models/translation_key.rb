module FastGettext::TranslationRepository
  module DbModels
    class TranslationKey < ActiveRecord::Base
      has_many :translations, :class_name=>'TranslationText'

      attr_accessible :key, :key_value, :translations_attributes
      accepts_nested_attributes_for :translations

      validates_uniqueness_of :key
      validates_presence_of :key

      named_scope :by_locale, proc { |loc|
        {
          :include => :translations,
          :conditions => loc.blank? ? nil : ["translation_texts.locale = ?", loc],
        }
      }

      named_scope :untranslated, {
        :include => :translations,
        :conditions => ["translation_texts.text LIKE ?", '%""%'],
      }

      def key_value=(value)
        write_attribute(:key, ActiveSupport::JSON.encode(value))
      end

      def key_value
        Db.decode_value(key)
      end

      validates_uniqueness_of :key
      validates_presence_of :key

      def self.translation(keys, locale)
        return unless translation_key = find_by_key(keys.to_json)
        return unless translation_text =
          translation_key.translations.find_by_locale(locale) ||
          translation_key.translations.find_by_locale(FastGettext.default_locale)
        translation_text.text_value
      end

      def self.available_locales
        @@available_locales ||= TranslationText.count(:group=>:locale).keys.sort
      end

      #this is only for ActiveSupport to get polymorphic_url FastGettext::... namespace free
      def self.model_name
        ActiveSupport::ModelName.new('TranslationKey')
      end

    end
  end
end