module Pagerduty
  module CLT
    module Status
      ACKNOWLEDGED = 'acknowledged'
      RESOLVED     = 'resolved'
      TRIGGERED    = 'triggered'
      UNRESOLVED   = [ TRIGGERED, ACKNOWLEDGED ]
    end
  end
end
