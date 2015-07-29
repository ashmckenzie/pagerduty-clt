module Pagerduty
  module CLT
    module Formatters
      module Incidents
        class Table

          include Formatters::Helper

          def initialize(incidents)
            @incidents = incidents
          end

          def render
            return nil if incidents.empty?
            puts TerminalTable.new(headings: columns, rows: rows, max_width: terminal_width).render
          end

          private

            attr_reader :incidents

            def columns
              {
                id:       { label: '#', max_width: 7 },
                node:     { label: 'Node', max_width: 28 },
                service:  { label: 'Service', max_width: 22 },
                detail:   { label: 'Detail', max_width: -1 },
                assignee: { label: 'Assignee', max_width: 22 },
                status:   { label: 'X', max_width: 1 },
                created:  { label: 'Created', max_width: 19 }
              }
            end

            def rows
              incidents.map do |incident|
                {
                  id:       incident.id,
                  node:     incident.node.name,
                  service:  incident.service.name,
                  detail:   incident.service.detail,
                  assignee: incident.user.name,
                  status:   incident.status_short,
                  created:  incident.created_at
                }
              end
            end

        end
      end
    end
  end
end
