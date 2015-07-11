module Pagerduty
  module CLT
    class Note

      attr_reader :raw

      def initialize(raw)
        @raw = raw
      end

      private

        # attr_reader :raw
    end
  end
end
