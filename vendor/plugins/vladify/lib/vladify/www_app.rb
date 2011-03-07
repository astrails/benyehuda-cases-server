namespace :remote do
  namespace :www_app do
    desc "start the app with first request"
    remote_task :request do
      run "curl -I http://www.#{domain.split(/@/).last}/"
    end
  end
end

namespace :deploy do
  task :restart => "remote:www_app:request"
end
