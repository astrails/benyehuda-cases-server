HoptoadNotifier.configure do |config|
  config.api_key = 'b5829a39945a374e55edda26ca92d34a'
  config.environment_filters << 'rack-bug.*'
  if "benyehuda" == `hostname`.strip
    config.proxy_host = 'proxy1.haifa.ac.il'
    config.proxy_port = 8080
  end
end
