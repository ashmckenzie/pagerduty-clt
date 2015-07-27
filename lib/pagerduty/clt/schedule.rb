module Pagerduty
  module CLT
    class Schedule

      include PathHelper  # FIXME
      extend PathHelper   # FIXME

      def initialize(raw)
        @raw = raw
      end

      def id
        @id ||= raw.id
      end

      def name
        @name ||= raw.name
      end

      def users
        @users ||= begin
          path = schedule_users_path(id)
          options = { since: Time.now.strftime('%Y-%m-%d'), until: (Time.now + 7 * 86_400).strftime('%Y-%m-%d') }
          $connection.get(path, options).users.map { |raw_user| User.new(raw_user) }
        end
      end

      private

        attr_reader :raw

    end
  end
end
