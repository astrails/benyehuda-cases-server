namespace :dj do
  %w/start stop restart/.each do |c|
    desc "#{c} delayed_job"
    task c.to_sym do
      system("sudo monit #{c} delayed_job-#{application}") || fail("Failed to #{c} delayed_job")
    end
  end
end

namespace :remote do
  namespace :dj do
    %w/start stop restart/.each do |c|
      desc "#{c} delayed_job"
      remote_task c, :roles => :app do
        run "cd #{current_path} && RAILS_ENV=#{rails_env} sudo monit #{c}  delayed_job-#{application}"
      end
    end
  end
end

namespace :deploy do
  task :restart => %w/remote:dj:restart/
end