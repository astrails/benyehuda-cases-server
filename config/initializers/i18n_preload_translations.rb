__END__
AVAILABLE_LOCALES.each { |loc| FastGettext.caches["app"][loc] ||= {} }

raise "BOOM" unless defined?(TranslationText)

module FastGettext::TranslationRepository
  module DbModels
    class TranslationText
      belongs_to :key, :class_name=>'TranslationKey', :foreign_key => :translation_key_id

      def self.preload

        bm = Benchmark.measure do
          TranslationText.all(:include => :key).each do |t|
            # puts "[#{t.locale}] #{t.key.key} = #{(t.text || false).inspect}"
            key = t.key.key
            text = t.text || false
            if key =~ /\|\|\|\|/
              # debugger
              key = ('||||' + key)
              text = text.split('||||')
            end

            FastGettext.caches["app"][t.locale][key] = text || false
          end
        end

        logger.info "Preloaded translations: %0.3f sec" % bm.real

      end

    end
  end
end

TranslationText.preload unless $0 =~ /rake/
