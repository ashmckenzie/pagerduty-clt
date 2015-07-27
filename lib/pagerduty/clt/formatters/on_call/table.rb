module Pagerduty
  module CLT
    module Formatters
      module OnCall
        class Table

          include Formatters::Helper

          def initialize(escalation_policies)
            @escalation_policies = escalation_policies
          end

          def render
            return nil if escalation_policies.empty?
            puts TerminalTable.new(headings: columns, rows: rows, max_width: 80).render
          end

          private

            attr_reader :escalation_policies

            def columns
              {
                name:   { label: 'Name', max_width: 50 },
                person: { label: 'Person', max_width: 23 }
              }
            end

            def rows
              escalation_policies.map do |escalation_policy|
                {
                  name:   escalation_policy.name,
                  person: escalation_policy.user_name
                }
              end
            end
        end
      end
    end
  end
end
