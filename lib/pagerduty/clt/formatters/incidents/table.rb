module Pagerduty
  module CLT
    module Formatters
      module Incidents
        class Table

          def initialize(incidents)
            @incidents = incidents
            @prepared_rows = {}
          end

          def render
            return nil if incidents.empty?
            puts Terminal::Table.new(headings: headings, rows: rows)
          end

          private

            attr_accessor :prepared_rows
            attr_reader :incidents

            def headings
              [
                '#',
                'Node',
                'Service',
                'Detail',
                'Assigned To',
                'Status',
                'Created'
              ]
            end

            def rows
              incidents.map do |incident|
                [
                  incident.id,
                  incident.node.name,
                  incident.service.name,
                  incident.service.detail,
                  incident.user.name,
                  incident.status,
                  incident.created_at
                ]
              end
            end
        end
      end
    end
  end
end
