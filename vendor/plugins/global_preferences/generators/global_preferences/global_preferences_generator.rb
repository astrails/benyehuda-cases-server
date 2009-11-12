
class GlobalPreferencesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template "migrations/create_global_preferences.rb", 'db/migrate', :migration_file_name => "create_global_preferences"
    end
  end
end

