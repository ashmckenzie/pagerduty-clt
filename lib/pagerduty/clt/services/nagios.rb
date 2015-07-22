module Pagerduty
  module CLT
    module Services
      class Nagios

        attr_reader :node, :raw

        def initialize(node, raw)
          @node = node
          @raw = raw
        end

        def name
          @service ||= raw.service
        end

        def state
          @state ||= raw.state
        end

        def detail
          @detail || begin
            details = if raw.details.SERVICEOUTPUT
              raw.details.SERVICEOUTPUT
            elsif raw.details.HOSTOUTPUT
              raw.details.HOSTOUTPUT
            else
              ''
            end

            details.gsub('br /', "\n")
          end
        end
      end
    end
  end
end
