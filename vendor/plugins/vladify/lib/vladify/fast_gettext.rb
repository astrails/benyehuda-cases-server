namespace :remote do
  namespace :gettext do
    desc "remote sync gettext to db"
    remote_task :sync do
      # only need to do it on one of the :app hosts
      break unless target_host == Rake::RemoteTask.hosts_for(:app).first
      run rake "sync_po_to_db"
    end
  end
end

namespace :deploy do
  task :config => "remote:gettext:sync"
end
