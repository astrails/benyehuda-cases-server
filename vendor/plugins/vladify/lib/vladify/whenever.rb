namespace :crontab do
  desc "update crontab"
  task :update do
    run "whenever --update-crontab #{application}"
  end
end

namespace :remote do
  namespace :crontab do
    desc "update remote crontab"
    remote_task :update do
      run "cd #{current_path} && whenever --update-crontab #{application}"
    end
  end
end

namespace :deploy do
  task :restart => "remote:crontab:update"
end