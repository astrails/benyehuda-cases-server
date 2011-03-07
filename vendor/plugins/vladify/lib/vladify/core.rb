# Load vlad
gem 'vlad', '1.4.0'
require 'vlad'
require 'vlad/core'

# standard deployment locations
set(:deploy_to) {"/var/www/#{application}"}
set(:scm_path) {"#{deploy_to}/scm"}

# deploy currently checked-out revision
set(:revision) {`git rev-parse HEAD`.strip}

# command to run a rake task in $current_path
def rake(target)
  res = "cd #{current_release} && #{rake_cmd} RAILS_ENV=#{rails_env} #{target}"
  puts res
  res
end

namespace :mod_rails do
  desc "Restart passenger"
  remote_task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
    puts "mod_rails restarted"
  end
end


namespace :vlad do

  # directories to create inside $shared_path
  set :mkdir_shared, []

  remote_task :setup_app, :roles => :app do
    unless mkdir_shared.empty?
      run "umask #{umask} && mkdir -vp #{mkdir_shared.map {|d| File.join(shared_path, d)} * ' '}"
    end
  end

  # links to create from $current_path to $shared_path
  set :ln_shared, []

  # stuff to do between source checkout and 'current' symlink
  remote_task :update_symlinks, :roles => :app do
    # copy ALL files inside shared/config to latest/config
    run "find #{shared_path}/config -type f | while read f; do cp -v $f #{latest_release}/${f\##{shared_path}/}; done"

    # link extra shared directories
    ln_shared.each do |d|
      run "mkdir -p #{shared_path}/#{d}"
      run "ln -sfn #{shared_path}/#{d} #{latest_release}/#{d}"
    end

    # link shared to latest/config/shared
    run "ln -sfn #{shared_path} #{latest_release}/config/shared"

    # current revision
    run "echo #{revision} > #{latest_release}/REVISION"
  end
end

namespace :git do
  desc "git push"
  task :push do
    system "git", "push"
  end
end

# regular deploy sequence
namespace :deploy do
  # update new sources, (links 'current')
  task :update => %w/git:push vlad:update/
  # configure. should not interfere with the running code
  task :config
  # stuff to do just before restarting.
  task :prepare => %w/vlad:migrate/
  # restart all the services
  task :restart => %w/mod_rails:restart/
  # cleanup
  task :cleanup => %w/vlad:cleanup/
end
task :deploy => %w/deploy:update deploy:config deploy:prepare deploy:restart deploy:cleanup/

# fast deploy sequence
namespace :qdeploy do
  task :update => "vlad:update"
  task :config
  task :prepare
  task :restart => "mod_rails:restart"
  task :cleanup
end
task :qdeploy => %w/qdeploy:update qdeploy:config qdeploy:prepare qdeploy:restart qdeploy:cleanup/

# LOAD VLAD
Vlad.load :scm => :git, :app => nil, :web => nil