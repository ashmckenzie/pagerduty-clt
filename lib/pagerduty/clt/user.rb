module Pagerduty
  module CLT
    class User

      include PathHelper
      extend PathHelper

      def initialize(raw)
        @raw = raw
      end

      def self.find(id, fields: false)
        path = user_path(id)
        options = {}
        options[:fields] = fields.join(',') if fields
        response = $connection.get(path, options)
        new(response)
      end

      def self.search(pattern, fields: false)
        path = users_path
        options = {}
        options[:fields] = fields.join(',') if fields
        response = $connection.get(path, options)
        response['users'].map { |raw_user| self.new(raw_user) }.select { |user| user.match?(pattern) }
      end

      def id
        @id ||= raw.id
      end

      def name
        @name ||= raw.name
      end

      def email
        @email ||= raw.email
      end

      def preferred_time_zone
        @preferred_time_zone ||= TZInfo::Timezone.get(time_zone)
      end

      def match?(pattern)
        !!(id.match(pattern) || name.match(pattern) || (email.match(pattern)))
      end

      def my_schedules
        @my_schedules ||= Regexp.new(ENV.fetch('PAGERDUTY_MY_SCHEDULES', '.*'))
      end

      private

        attr_reader :raw

        def raw_time_zone
          @raw_time_zone ||= begin
            tz = if ENV['PAGERDUTY_PREFERRED_TIME_ZONE']
              ENV['PAGERDUTY_PREFERRED_TIME_ZONE']
            else
              raw.time_zone
            end
            tz == 'Pacific Time (US & Canada)' ?  'US/Pacific' : raw.time_zone
          end
        end

        def time_zone
          match = TZInfo::Timezone.all_identifiers.detect { |x| x.match(/#{raw_time_zone}/) }
          fail "Unable to accurately determine time zone based off '%s'" % raw_time_zone unless match
          match
        end
    end

    NullUser = Naught.build do |config|
      config.mimic User

      def name
        ''
      end
    end
  end
end
