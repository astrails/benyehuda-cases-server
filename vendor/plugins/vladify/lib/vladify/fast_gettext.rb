def gettext_flatten_locales_hash(h, prefix = nil)
  h.inject({}) do |res,e|
    k, v = e
    k = "#{prefix}.#{k}" if prefix
    res.merge v.is_a?(Hash) ? gettext_flatten_locales_hash(v, k) : {k => v}
  end
end

namespace :gettext do
  desc "sync locales .yml file to db"
  task :yml => :environment do
    I18n.load_path.flatten.each do |filename|
      next unless File.exists?(filename)
      messages = gettext_flatten_locales_hash(YAML.load(File.read(filename)))
      messages.each do |k, v|
        unless key = TranslationKey.find_by_key(k.to_json)
          puts "new error message key: #{k}"

          TranslationKey.create(:key_value => k,
            :translations_attributes => AVAILABLE_LOCALES.map {|loc| {:locale => loc, :text_value => v}})
        end
      end
    end
  end
end

namespace :remote do
  namespace :gettext do
    desc "remote sync gettext to db"
    remote_task :sync do
      # only need to do it on one of the :app hosts
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first
      run rake "gettext:yml"
      run rake "gettext:sync"
    end
  end
end

namespace :deploy do
  task :config => "remote:gettext:sync"
end
