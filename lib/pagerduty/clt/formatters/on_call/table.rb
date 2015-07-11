module Pagerduty
  module CLT
    module Formatters
      module OnCall
        class Table

          def initialize(escalation_policies)
            @escalation_policies = escalation_policies
            @prepared_rows = {}
          end

          def render
            return nil if escalation_policies.empty?
            puts Terminal::Table.new(headings: headings, rows: rows)
          end

          private

            attr_accessor :prepared_rows
            attr_reader :escalation_policies

            def headings
              [
                'Name',
                'Person'
              ]
            end

            def rows
              escalation_policies.map do |escalation_policy|
                [
                  escalation_policy.name,
                  escalation_policy.user_name
                ]
              end
            end
        end
      end
    end
  end
end
