module Pagerduty
  module CLT
    class EscalationPolicy

      def initialize(raw)
        @raw = raw
      end

      def name
        @name ||= raw.name
      end

      def user_name
        @user_name ||= raw.on_call.first.user.name
      end

      private

        attr_reader :raw

    end
  end
end
