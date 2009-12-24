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

      def text
        return nil unless value = read_attribute(:text)
        value = ActiveSupport::JSON.decode(value)
        return nil if value.blank?
        return value unless value.is_a?(Array)
        value.map {|v| v.blank? ? nil : v} # replace "" with nil
      end
    end
  end
end