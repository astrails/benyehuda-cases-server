module AWS
  module S3
    class Connection
      class << self
        def connect_with_proxy(options = {})
          connect_without_proxy(options.merge(:proxy => {:host => PROXY_HOST, :port => PROXY_PORT})
        end
        alias_method_chain(:connect, :proxy) if defined?(PROXY_HOST) && defined?(PROXY_PORT)
      end
    end
  end
end
