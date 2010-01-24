class TranslationKeysController < InheritedResources::Base
  unloadable
  # should be defined in the ApplicationController by the user
  # can usually be just an alias to require_admin
  before_filter :authenticate_translations_admin
  actions :all, :except => :show

  has_scope :by_locale, :only => [:index, :edit]
  has_scope :untranslated, :boolean => true , :only => :index

  def new
    build_resource
    add_default_locales_to_translation
    new! do |fmt|
      fmt.html {render :action => :edit}
    end
  end

  def create
    create! do |s,f|
      s.html {redirect_to translation_keys_path(:by_locale => by_locale, :untranslated => untranslated)}
      f.html {render :action => :edit}
    end
  end

  def update
    update! do |s,f|
      s.html {redirect_to translation_keys_path(:by_locale => by_locale, :untranslated => untranslated)}
      f.html {render :action => :edit}
    end
  end

  def destroy
    destroy! {translation_keys_path}
  end

  protected

  def add_default_locales_to_translation
    all_available_locales.each do |locale|
      @translation_key.translations.build(:locale=>locale)
    end
  end

  protected

  def all_available_locales
    @all_locales ||= (TranslationKey.available_locales + AVAILABLE_LOCALES).sort.uniq
  end

  def by_locale
    params[:by_locale].blank? ? nil : params[:by_locale]
  end

  def untranslated
    params[:untranslated].blank? ? nil : params[:untranslated]
  end

  def locales_to_edit
    by_locale ? [by_locale] : all_available_locales
  end

  helper_method :all_available_locales, :by_locale, :untranslated, :locales_to_edit
end