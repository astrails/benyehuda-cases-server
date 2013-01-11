source 'http://rubygems.org'

gem 'rails', '3.0.19'
gem 'rake', '0.8.7'

gem "builder"
gem "json"
gem "mysql"
gem 'authlogic'
gem 'whenever'
gem 'will_paginate', "2.3.15", :require => 'will_paginate'
gem "tzinfo"
gem 'formtastic'
gem 'sass'
gem 'haml'
gem 'fast_gettext'
gem 'ruby_parser', :require => false
gem "aasm"
gem 'mime-types', :require => 'mime/types'
gem "fastercsv"
gem 'airbrake'
gem 'thinking-sphinx', :require => 'thinking_sphinx'
gem 'gravtastic', "2.2.0"
gem 'vlad', '1.4.0', :require => false
gem "RubyInline"
gem "daemons"
gem 'high_voltage'
gem 'inherited_resources'
gem 'has_scope'
gem 'hoe', '2.8.0'
#gem 'grosser-pomo', :source => "http://gems.github.com/", :version => '>=0.5.1'

gem 'aws-s3', :require => "aws/s3"
gem 'paperclip', '~>2.4.5'  # XXX until we're in the 1.9 land
#gem 'paperclip', :git => "git://github.com/jeanmartin/paperclip.git", :branch => "master"

gem 'jquery-rails', '>= 1.0.12'

gem 'image_science', :require => false
gem 'rmagick'
gem 'mini_magick'

gem 'astrails-safe'

# TODO sort this out
gem 'ZenTest', '4.0.0'
gem 'test-unit', '1.2.3'
gem "ruby-debug#{RUBY_VERSION =~ /1.9/ ? '19' : ''}", :require => 'ruby-debug'

group :production do
  gem "passenger", '2.2.11'
end

group :development do
  gem 'rspec-rails'
  gem 'rspec'
  gem 'mocha'
  #gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
end

group :test do
  gem 'rspec-rails'
  gem 'rspec'
  gem 'mocha'
  gem 'factory_girl_rails', '1.4.0'
  #gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  gem 'rspec2-rails-views-matchers'
end
