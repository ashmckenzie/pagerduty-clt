module Pagerduty
  module CLT
    module Formatters
      module Incidents
        class TableDetailed

          include Formatters::Helper

          def initialize(incidents)
            @incidents = incidents
          end

          def render
            return nil if incidents.empty?
            TerminalTable.new(headings: headings, data: data, style: 'row_headings', max_width: terminal_width).render
          end

          private

            attr_reader :incidents

            def headings
              {
                id:       { label: '#' },
                node:     { label: 'Node' },
                service:  { label: 'Service' },
                detail:   { label: 'Detail' },
                assignee: { label: 'Assignee' },
                status:   { label: 'X' },
                created:  { label: 'Created' }
              }
            end

            def data
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
