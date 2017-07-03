module Pagerduty
  module CLT
    class MySchedules

      include Base
      include PathHelper

      def all
        where
      end

      def where
        get
      end

      private

        # FIXME: DRY UP
        def get
          schedules = []
          jobs = []

          response = $connection.get(schedules_path)
          response.schedules.each_with_index do |raw_schedule_summary, i|
            next unless me.my_schedules.match?(raw_schedule_summary.name)
            jobs << Thread.new do
              raw_schedule_detailed = $connection.get(schedule_path(raw_schedule_summary.id))
              schedules[i] = Schedule.new(raw_schedule_detailed.schedule)
            end
          end

          jobs.each(&:join)
          schedules.compact
        end

    end
  end
end
