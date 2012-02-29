source "http://gems.github.com"
source :gemcutter
gem "builder", "3.0.0"
gem "rails", "2.3.4"
gem "json", "1.5.1"
gem "mysql", "2.8.1"
gem 'authlogic', '2.1.1'
gem 'ruby-debug'
gem 'whenever'
gem 'will_paginate',  "2.3.15", :require => 'will_paginate'
gem "tzinfo", "0.3.24"
gem 'formtastic',  '0.9.1'
gem 'haml',  "3.0.25"
gem "gettext", '2.1.0'
#gem 'fast_gettext', '0.4.17', :git => "https://github.com/grosser/fast_gettext.git", :tag => "v0.4.17"
gem 'fast_gettext', '0.4.17', :path => "./vendor/gems/fast_gettext-0.4.17"
gem "grosser-pomo", '>=0.5.1'
gem "aasm", "2.1.3"
gem 'mime-types', "1.16", :require => 'mime/types'
gem "fastercsv", "1.5.0"
gem 'hoptoad_notifier', "2.3.2"
gem 'thinking-sphinx', '1.3.15', :require => 'thinking_sphinx'
gem 'gravtastic',  '2.2.0'
gem "vlad", "1.4.0"
gem "aws-s3", '0.5.1', :require => "aws/s3"
gem 'right_aws', '1.10.0'
gem 'image_science', '1.2.1'
gem "RubyInline"
gem "daemons", "1.1.0"

# bundler requires these gems in all environments
# gem "nokogiri", "1.4.2"
# gem "geokit"

group :production do
  gem "passenger", "2.2.11"
end

group :development do
  # bundler requires these gems in development
  # gem "rails-footnotes"
  gem 'rspec-rails', '1.3.2'
  gem 'rspec', '1.3.0'
  gem 'mocha','0.9.8'
  gem "inaction_mailer"

  gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  gem "ruby-debug", :require => 'ruby-debug'
end

group :test do
  gem 'rspec-rails', '1.3.2'
  gem 'rspec', '1.3.0'
  gem 'mocha','0.9.8'
  gem 'factory_girl'
  gem 'inaction_mailer', :require => 'inaction_mailer/force_load'
  gem 'query_trace', :require => 'query_trace'
  gem "ruby-debug", :require => 'ruby-debug'
  # bundler requires these gems while running tests
  # gem "rspec"
  # gem "faker"
end

