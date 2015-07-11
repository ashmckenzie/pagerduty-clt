require 'oj'
require 'hashie'
require 'faraday'
require 'faraday_middleware'
require 'faraday/http_cache'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module Pagerduty
  module CLT
    class Connection

      def initialize(name, token)
        @name = name
        @token = token
      end

      def get(path, args={})
        res = request(:get, path, args)
        Hashie::Mash.new(Oj.load(res.body))
      end

      def put(path, args={})
        res = request(:put, path, args)
        Hashie::Mash.new(Oj.load(res.body))
      end

      def handle
        @handle ||= begin
          Faraday.new(url: base_url) do |builder|
            builder.adapter(:typhoeus)

            builder.use(Faraday::Response::RaiseError)
            builder.use(Faraday::Response::Logger) if ENV['DEBUG'] == 'true'

            builder.use(FaradayMiddleware::Caching, ConnectionCacheStore.new($logger))

            builder.token_auth(token)

            builder.headers[:user_agent] = 'PD-CLT/1.0'
            builder.headers[:content_type] = 'application/json'
          end
        end
      end

      private

        attr_reader :name, :token

        def base_url
          @base_url ||= 'https://%s.pagerduty.com/api/v1' % name
        end

        def request(method, path, args)
          full_path = "%s/%s" % [ base_url, path ]
          handle.send(method, full_path, args, nil)
        end

    end
  end
end
