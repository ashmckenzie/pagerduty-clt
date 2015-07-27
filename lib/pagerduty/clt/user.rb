module Pagerduty
  module CLT
    class User

      def initialize(raw)
        @raw = raw
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
