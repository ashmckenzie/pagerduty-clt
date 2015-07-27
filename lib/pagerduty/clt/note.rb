module Pagerduty
  module CLT
    class Note

      def initialize(raw)
        @raw = raw
      end

      private

        attr_reader :raw
    end
  end
end
