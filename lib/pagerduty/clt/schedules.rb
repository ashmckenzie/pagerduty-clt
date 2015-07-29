module Pagerduty
  module CLT
    class Schedules

      include Base
      include PathHelper

      def all
        where
      end

      def where(query: nil)
        get(query)
      end

      private

        def get(query)
          schedules = []
          options = {}
          options[:query] = query if query

          jobs = []
          response = $connection.get(schedules_path)
          response.schedules.each_with_index do |raw_schedule_summary, i|
            jobs << Thread.new do
              raw_schedule_detailed = $connection.get(schedule_path(raw_schedule_summary.id), options)
              schedules[i] = Schedule.new(raw_schedule_detailed.schedule)
            end
          end

          jobs.each(&:join)
          schedules
        end

    end
  end
end
