def gettext_flatten_locales_hash(h, prefix = nil)
  h.inject({}) do |res,e|
    k, v = e
    k = "#{prefix}.#{k}" if prefix
    res.merge v.is_a?(Hash) ? gettext_flatten_locales_hash(v, k) : {k => v}
  end
end

namespace :gettext do
  namespace :sync do
    desc "sync locales .yml file to db"
    task :locales => :environment do
      locales_path = File.read(File.join(RAILS_ROOT, "config", "locales", "en.yml"))
      if File.exists?(locales_path)
        messages = gettext_flatten_locales_hash(YAML.load(locales_path))
        messages.each do |k, v|
          unless key = TranslationKey.find_by_key(k)
            puts "new error message key: #{k}"

            TranslationKey.create(:key => k,
              :translations_attributes => AVAILABLE_LOCALES.map {|loc| {:locale => loc, :text => ('en' == loc) ? v : nil}})
          end
        end
      end
    end

    desc "sync gettext .po files to db"
    task :po => :sync_po_to_db
  end
end

namespace :remote do
  namespace :gettext do
    desc "remote sync gettext to db"
    remote_task :sync do
      # only need to do it on one of the :app hosts
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first
      Rake::Task["gettext:sync:locales"].invoke
      Rake::Task["gettext:sync:po"].invoke
    end
  end
end

namespace :deploy do
  task :config => "remote:gettext:sync"
end