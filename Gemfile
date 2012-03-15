#source "http://gems.github.com"
#source :gemcutter
source 'http://rubygems.org'

gem 'rails', '3.0.4'
gem "rake", "0.8.7"
gem "builder"
gem "json"
gem "mysql"
gem 'authlogic'
gem 'ruby-debug'
gem 'whenever'
gem 'will_paginate', "2.3.15",:require => 'will_paginate'
gem "tzinfo"
gem 'formtastic', '~> 1.1.0'
gem 'haml'
gem "gettext"
#gem 'fast_gettext', '0.4.17', :git => "https://github.com/grosser/fast_gettext.git", :tag => "v0.4.17"
gem 'fast_gettext' #, :require => false #, :path => "./vendor/gems/fast_gettext-0.4.17"
#gem 'gettext_i18n_rails'
#gem "grosser-pomo", '>=0.5.1'
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
  gem 'factory_girl_rails'
  #gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  gem "ruby-debug", :require => 'ruby-debug'
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
end
