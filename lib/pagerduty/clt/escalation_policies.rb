module Pagerduty
  module CLT
    class EscalationPolicies

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
          response = $connection.get(escalation_policy_path(query))
          response.escalation_policies.map do |raw_escalation_policy|
            EscalationPolicy.new(raw_escalation_policy)
          end
        end

    end
  end
end
