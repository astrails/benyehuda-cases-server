#source "http://gems.github.com"
#source :gemcutter
source 'http://rubygems.org'

gem 'rails', '3.0.11'
gem "rake", "0.8.7"
gem "builder"
gem "json"
#gem "mysql2", '0.2.7'
gem "mysql"
gem 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git'
gem "ruby-debug#{RUBY_VERSION =~ /1.9/ ? '19' : ''}", :require => 'ruby-debug'
gem 'whenever'
gem 'will_paginate', "2.3.15", :require => 'will_paginate'
gem "tzinfo"
gem 'formtastic'
gem 'sass'
gem 'haml'
gem 'fast_gettext', :git => 'git://github.com/astrails/fast_gettext.git'
gem 'ruby_parser', :require => false
gem "aasm"
gem 'mime-types', :require => 'mime/types'
gem "fastercsv"
# TODO: replace with airbrake, see also config/initializers/hoptoad.rb and lib/tasks/hoptoad_notifier_tasks.rake: gem 'hoptoad_notifier'
gem 'thinking-sphinx', :require => 'thinking_sphinx'
gem 'gravtastic', "2.2.0"
gem 'vlad', '1.4.0', :require => false
gem "aws-s3", :require => "aws/s3"
gem 'right_aws'
gem 'image_science', :require => false
gem "RubyInline"
gem "daemons"
gem 'high_voltage'
gem 'inherited_resources'
gem 'has_scope'
gem 'ZenTest', '4.0.0'
gem 'hoe', '2.8.0'
#gem 'grosser-pomo', :source => "http://gems.github.com/", :version => '>=0.5.1'

gem 'jquery-rails', '>= 1.0.12'

gem 'test-unit', '1.2.3'
gem 'rmagick'
gem 'mini_magick'

# bundler requires these gems in all environments
# gem "nokogiri", "1.4.2"
# gem "geokit"

group :production do
  gem "passenger", '2.2.11'
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
end

group :test do
  gem 'rspec-rails'
  gem 'rspec'
  gem 'mocha'
  gem 'factory_girl_rails'
  #gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
  gem 'rspec2-rails-views-matchers'
end
