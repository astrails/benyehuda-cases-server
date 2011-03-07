namespace :dj do
  %w/start stop restart/.each do |c|
    desc "#{c} delayed_job"
    task c.to_sym do
      system("RAILS_ENV=#{RAILS_ENV} script/delayed_job #{c}") || fail("Failed to #{c} delayed_job")
    end
  end
end

namespace :remote do
  namespace :dj do
    %w/start stop restart/.each do |c|
      desc "#{c} delayed_job"
      remote_task c, :roles => :dj do
        run "cd #{current_path} && RAILS_ENV=#{rails_env} script/delayed_job #{c}"
      end
    end
  end
end

namespace :deploy do
  task :restart => %w/remote:dj:stop remote:dj:start/
end