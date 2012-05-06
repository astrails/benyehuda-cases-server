module I18n
  module_function
  # this is not chainable, since FastGettext may reject this locale!
  def locale=(new_locale)
    FastGettext.locale = new_locale
  end
  def locale
    FastGettext.locale.to_sym
  end

  def with_locale(new_locale)
    begin
      old_locale, I18n.locale = I18n.locale, new_locale
      yield
    ensure
      I18n.locale = old_locale
    end
  end
end