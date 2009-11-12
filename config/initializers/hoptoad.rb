HoptoadNotifier.configure do |config|
  config.api_key = 'foo'
  config.environment_filters << 'rack-bug.*'
end
