ln_shared << ".bundle"

namespace :bundle do
  desc "install bundled gems"
  task :install do
    run "bundle install --without test development"
  end
end

namespace :remote do
  namespace :bundle do
    desc "remote bundle install"
    remote_task :install, :roles => :app do
      run "cd #{current_release} && bundle install --without test"
    end

  end
end

namespace :vlad do
  remote_task :update_symlinks, :roles => :app do
    Rake::Task['remote:bundle:install'].invoke
  end
end
