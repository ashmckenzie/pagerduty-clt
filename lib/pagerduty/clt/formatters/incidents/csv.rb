module Pagerduty
  module CLT
    module Formatters
      module Incidents
        class CSV

          def initialize(incidents)
            @incidents = incidents
          end

          def render
            return nil if incidents.empty?
            [ header, rows ].join("\n")
          end

          private

            attr_reader :incidents

            def header
              [
                'id',
                'node',
                'service',
                'detail',
                'assignee',
                'status',
                'created',
              ].join(',')
            end

            def rows
              incidents.map do |incident|
                [
                  incident.id,
                  incident.node.name,
                  incident.service.name,
                  incident.service.detail,
                  incident.user.name,
                  incident.status_short,
                  incident.created_at
                ].join(',')
              end
            end

        end
      end
    end
  end
end
