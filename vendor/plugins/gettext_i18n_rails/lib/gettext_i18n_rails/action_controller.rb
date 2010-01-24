class ActionController::Base
  protected

  helper_method :valid_locale?, :default_locale, :current_locale,
    :home_path, :locale_url_for, :locale_domain_for

  # returns true if "locale" is supported
  def valid_locale?(locale)
    FastGettext.available_locales.include?(locale)
  end

  # returns the default locale. by default this is just the first available one
  # can be overwritten in ApplicationController
  def default_locale
    FastGettext.available_locales.first
  end

  def current_locale
    FastGettext.locale
  end

  # parses the hostname:port
  # returns a tripple of (locale, basedomain, port)
  # ignores www at the beginning and only accepts valid locales
  # examples:
  #     www.foobar.com:3000   =>  [nil, "foobar.com", "3000"]
  #     en.foobar.com         =>  ["en", "foobar.com", nil]
  def parse_host_and_port_for_locale
    @parsed_host_and_port ||= begin
      parts = request.host_with_port.split('.')

      parts.shift if parts.first == 'www'

      lang = parts.shift if valid_locale?(parts.first)

      host, port = parts.join('.').split(':')
      [lang, host, port]
    end
  end

  # returns locala from a 'source'
  # available sources are :params, :session, :cookie, :domain, :header, and :default
  # default just returns the default_locale
  # return nil if locale can't be found from the source
  def detect_locale_from(source)
    case source
    when :params
      params[:locale]
    when :session
      logger.debug "Session: #{session.inspect}"
      session[:locale]
    when :cookie
      cookies[:locale]
    when :domain
      parse_host_and_port_for_locale[0]
    when :header
      request.env['HTTP_ACCEPT_LANGUAGE']
    when :default
      default_locale
    else
      raise "unknown source"
    end
  end

  def detect_locale(sources)
    sources.each do |source|
      if locale = detect_locale_from(source)
        logger.debug "detected #{locale.inspect} from #{source.inspect}"
        return locale
      end
    end
    default_locale
  end

  # detect and set current session locale
  # you can pass opts[:session_domain] to set as the domain for the session
  # or just pass 'true' to use currenly parsed base domain for it (w/o the www and/or language part)
  def set_gettext_locale(sources)
    sources ||= [:params, :session, :cookie, :domain, :header, :default]
    session[:locale] = FastGettext.set_locale(detect_locale(sources))
  end

  def canonic_session_domain(session_domain = true)
    return unless session_domain

    session_domain = parse_host_and_port_for_locale[1] if true == session_domain

    return session_domain unless session_domain.downcase == "localhost"

    logger.debug "can't use 'localhost' as session domain. leaving it default."
    nil
  end

  # sets session's domain settings
  # this is needed so that the cookie will be set on some 'base' domain
  # and thus be available on child subdomains, so that for example
  # session will be shared between en.domain.com and ru.domain.com
  # you can pass the desired session_domain or just 'true' for autodetection
  def set_session_domain(session_domain = true)
    return unless session_domain = canonic_session_domain(session_domain)

    if request.env['rack.session.options']
      logger.debug "set session domain = #{session_domain}"
      request.env['rack.session.options'][:domain] = session_domain
    else
      logger.debug "can't set session domain. there are no rack.session.options"
    end
  end

  def locale_domain_for(locale)
    _, domain, port = parse_host_and_port_for_locale
    domain = "#{domain}:#{port}" if port && port != "80"
    (locale == default_locale) ? domain : locale + "." + domain
  end

  # returns 'home' path to redirect to. override in ApplicationController
  def home_path
    "/"
  end

  def locale_url_for(locale)
    if request.get?
      url_for(params.merge(:locale => locale, :host => locale_domain_for(locale)))
    else
      request.protocol + locale_domain_for(locale) + home_path + "?locale=" + locale
    end
  end

  # this filter will redirect to canonic domain if needed.
  def redirect_to_canonic_domain
    return unless request.get?
    locale_domain = locale_domain_for(current_locale)
    return if request.host_with_port == locale_domain
    redirect_to(locale_url_for(current_locale))
  end

  def setup_localization(options = {})
    set_gettext_locale(options[:sources])
    set_session_domain(options[:session_domain])
    redirect_to_canonic_domain if options[:canonic_redirect]
  end
end
