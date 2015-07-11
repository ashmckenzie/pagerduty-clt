module Pagerduty
  module CLT
    module Services
      class Datadog

        attr_reader :raw

        def initialize(raw)
          @raw = raw
        end

        def name
          @service ||= raw.summary
        end

        def state
          'CRITICAL'
        end

        def detail
          @detail || raw.details.body.gsub('br /', "\n")
        end
      end
    end
  end
end
