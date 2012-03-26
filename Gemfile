#source "http://gems.github.com"
#source :gemcutter
source 'http://rubygems.org'

gem 'rails', '3.0.11'
gem "rake", "0.8.7"
gem "builder"
gem "json"
gem "mysql"
gem 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
gem 'ruby-debug'
gem 'whenever'
gem 'will_paginate', "2.3.15", :require => 'will_paginate'
gem "tzinfo"
gem 'formtastic'
gem 'haml'
gem 'gettext_i18n_rails'
gem 'gettext', '>=1.9.3', :require => false
gem 'ruby_parser', :require => false
gem "aasm"
gem 'mime-types', :require => 'mime/types'
gem "fastercsv"
gem 'hoptoad_notifier'
gem 'thinking-sphinx', :require => 'thinking_sphinx'
gem 'gravtastic', "2.2.0"
gem "vlad", "1.4.0"
gem "aws-s3", :require => "aws/s3"
gem 'right_aws'
gem 'image_science', :require => false
gem "RubyInline"
gem "daemons"
gem 'high_voltage'
gem 'inherited_resources'

gem 'jquery-rails', '>= 1.0.12'

# bundler requires these gems in all environments
# gem "nokogiri", "1.4.2"
# gem "geokit"

group :production do
  gem "passenger", "2.2.11"
end

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
  gem 'rspec-rails'
  gem 'rspec'
  gem 'mocha'
  #gem "inaction_mailer"

  #gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  gem "ruby-debug", :require => 'ruby-debug'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec'
  gem 'mocha'
  gem 'factory_girl_rails', "1.7.0"
  #gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  gem "ruby-debug", :require => 'ruby-debug'
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
  gem 'rspec2-rails-views-matchers'
end
