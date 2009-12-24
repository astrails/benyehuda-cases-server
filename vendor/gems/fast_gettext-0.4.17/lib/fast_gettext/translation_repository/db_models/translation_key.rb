module FastGettext::TranslationRepository
  module DbModels
    class TranslationKey < ActiveRecord::Base
      has_many :translations, :class_name=>'TranslationText'

      attr_accessible :key
      accepts_nested_attributes_for :translations, :allow_destroy => true

      def key=(value)
        write_attribute(:key, value.blank? ? nil : ActiveSupport::JSON.encode(value))
      end

      validates_uniqueness_of :key
      validates_presence_of :key

      def self.translation(keys, locale)
        return unless translation_key = find_by_key(keys.to_json)
        return unless translation_text = translation_key.translations.find_by_locale(locale)
        translation_text.text
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