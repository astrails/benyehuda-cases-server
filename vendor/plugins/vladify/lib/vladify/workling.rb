WORKLING_TASKS = %w/start stop restart status run zap/
namespace :workling do
  WORKLING_TASKS.each do |cmd|
    desc "#{cmd} workling"
    task cmd do
      system "script/workling_client #{cmd}" or fail "Failed to #{cmd} workling"
    end
  end
end

namespace :remote do
  namespace :workling do
    WORKLING_TASKS.each do |cmd|
      desc "remote #{cmd} workling"
      task cmd do
        run "cd #{current_path} && script/workling_client #{cmd}"
      end
    end
  end
end

namespace :deploy do
  task :restart => "remote:workling:restart"
end