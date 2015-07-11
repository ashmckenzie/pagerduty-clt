module Pagerduty
  module CLT
    class ConnectionCacheStore
      attr_accessor :store_hash

      def initialize(logger)
        @logger = logger
        @store_hash = {}
      end

      def write(key, value)
        @store_hash[key.to_sym] = value
      end

      def read(key)
        @store_hash[key.to_sym]
      end

      def fetch(key)
        raise('Block should be provided') unless block_given?
        result = read(key)

        $logger.debug("Fetching key=[%s], cached?=[%s]" % [ key, !result.nil? ])

        if result.nil?
          result = yield
          write(key, result)
          result
        else
          result
        end
      end

      private

        attr_reader :logger
    end
  end
end
