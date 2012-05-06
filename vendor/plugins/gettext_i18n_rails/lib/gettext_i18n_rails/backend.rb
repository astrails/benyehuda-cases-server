module GettextI18nRails
  #translates i18n calls to gettext calls
  class Backend
    @@translate_defaults = true
    cattr_accessor :translate_defaults
    attr_accessor :backend

    def initialize(*args)
      self.backend = I18n::Backend::Simple.new(*args)
    end

    def available_locales
      FastGettext.available_locales || []
    end

    def translate_without_interpolation(locale, key, options)
      flat_key = flatten_key key, options
      if FastGettext.key_exist?(flat_key)
        raise "no yet build..." if options[:locale]
        _(flat_key)
      else
        if options[:count]
          try_key = flat_key + (1 == options[:count] ? ".one" : ".other")
          return FastGettext._(try_key) if FastGettext.key_exist?(try_key)
        end
        if self.class.translate_defaults
          options[:default].to_a.each do |default|
            #try the more specific key first e.g. 'activerecord.errors.my custom message'
            flat_key = flatten_key default, options
            return FastGettext._(flat_key) if FastGettext.key_exist?(flat_key)

            #try the short key thereafter e.g. 'my custom message'
            return FastGettext._(default) if FastGettext.key_exist?(default)
          end
        end
        backend.translate locale, key, options
      end
    end

    def translate(locale, key, options)
      res = translate_without_interpolation(locale, key, options)

      reserved = :scope, :default, :locale
      values = options.reject { |name, value| reserved.include?(name) }

      backend.send :interpolate, locale, res, values
    end


    def method_missing(method, *args)
      backend.send(method, *args)
    end

    protected

    def flatten_key key, options
      scope = [*(options[:scope] || [])]
      scope.empty? ? key.to_s : "#{scope*'.'}.#{key}"
    end
  end
end