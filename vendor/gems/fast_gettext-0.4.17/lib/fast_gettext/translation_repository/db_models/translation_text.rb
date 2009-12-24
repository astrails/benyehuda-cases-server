module FastGettext::TranslationRepository
  module DbModels
    class TranslationText < ActiveRecord::Base
      belongs_to :key, :class_name=>'TranslationKey'

      attr_accessible :text, :locale
      validates_presence_of :translation_key_id
      validates_presence_of :locale
      validates_uniqueness_of :locale, :scope=>:translation_key_id

      def text=(value)
        write_attribute(:text, ActiveSupport::JSON.encode(value))
      end

    end
  end
end