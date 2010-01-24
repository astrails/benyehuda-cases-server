module FastGettext::TranslationRepository
  module DbModels
    class TranslationText < ActiveRecord::Base
      belongs_to :key, :class_name=>'TranslationKey', :foreign_key => :translation_key_id

      attr_accessible :text, :text_value, :locale
      validates_presence_of :locale
      validates_uniqueness_of :locale, :scope=>:translation_key_id

      def text_value=(value)
        write_attribute(:text, ActiveSupport::JSON.encode(value))
      end

      def text_value
        Db.decode_value(text)
      end

    end
  end
end