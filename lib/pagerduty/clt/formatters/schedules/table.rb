module Pagerduty
  module CLT
    module Formatters
      module Schedules
        class Table

          def initialize(schedules)
            @schedules = schedules
          end

          def render
            return nil if schedules.empty?
            puts TerminalTable.new(headings: columns, rows: rows, max_width: 140).render
          end

          private

            attr_reader :schedules

            def columns
              {
                name:   { label: 'Name', max_width: 35 },
                people: { label: 'People', max_width: -1 }
              }
            end

            def rows
              schedules.map do |schedule|
                {
                  name:   schedule.name,
                  people: schedule.users.map(&:name).join(', ')
                }
              end
            end
        end
      end
    end
  end
end
