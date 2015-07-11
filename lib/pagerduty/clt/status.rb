module Pagerduty
  module CLT
    module Status
      ACKNOWLEDGED = 'acknowledged'
      RESOLVED     = 'resolved'
      TRIGGERED    = 'triggered'

      ALL = [ ACKNOWLEDGED, RESOLVED, TRIGGERED ]
    end
  end
end
