gem "fast_gettext", :source => "http://gemcutter.org/"
gem "gettext", :source => "http://gemcutter.org/", :lib => false
gem "ruby_parser", :source => "http://gemcutter.org/", :lib => false
text_field_tag

./script/runner "puts Gem.loaded_specs['fast_gettext'].to_yaml" > vendor/gems/fast_gettext-0.4.17/.specification