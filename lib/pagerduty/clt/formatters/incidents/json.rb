module Pagerduty
  module CLT
    module Formatters
      module Incidents
        class JSON

          def initialize(incidents)
            @incidents = incidents
          end

          def render
            return nil if incidents.empty?
            ::JSON.pretty_generate(rows)
          end

          private

            attr_reader :incidents

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
