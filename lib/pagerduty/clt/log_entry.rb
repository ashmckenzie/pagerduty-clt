module Pagerduty
  module CLT
    class LogEntry

      attr_reader :raw

      def initialize(raw)
        @raw = raw
      end

      def id
        @id ||= raw.id
      end

      def type
        @type ||= raw.type
      end

      def timestamp
        @timestamp ||= raw.created_at
      end

      def channel
        @channel ||= raw.channel
      end

      private

        # attr_reader :raw
    end
  end
end
