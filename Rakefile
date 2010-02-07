# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))
require 'ruby-debug'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
require 'thinking_sphinx/tasks'

task :cruise_control do
  system "cp ../database.yml config/database.yml"
  Rake::Task['db:migrate'].invoke
  Rake::Task['default'].invoke
end

