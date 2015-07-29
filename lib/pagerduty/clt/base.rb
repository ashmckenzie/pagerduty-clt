module Pagerduty
  module CLT
    module Base

      def settings
        @settings ||= $config.settings
      end

      def me
        @me ||= $config.me
      end

      def nice_timestamp(str)
        ts = DateTime.parse(str)
        local = $config.me.preferred_time_zone.utc_to_local(ts)
        local.strftime('%Y-%m-%d %H:%M:%S')
      end
    end
  end
end
