require "vladify/delayed_job"
# require "vladify/delayed_job_monit"
require "vladify/fast_gettext"
# require "vladify/gettext"
require "vladify/thinking_sphinx"
# require "vladify/ultrasphinx"
require "vladify/whenever"
# require "vladify/workling"
require 'vladify/bundler'


set :repository, "git@alpha.astrails.com:benyehuda/cases_server"

desc "production server"
task :prod do
  set :application, "tasks.benyehuda.org"
  set :domain, "astrails@tasks.benyehuda.org"
end

desc "stage server"
task :staging do
  set :application, "staging.benyehuda.org"
  set :domain, "astrails@tasks.benyehuda.org"
end

# desc "beta server"
# task :beta do
#   set :application, "benyehuda.org"
#   set :domain, "astrails@benyehuda.astrails.com"
# end
# 
# desc "ui server"
# task :ui do
#   set :application, "benyehuda-ui.astrails.com"
#   set :domain, "astrails@benyehuda.astrails.com"
# end
