require 'terminfo'

module Pagerduty
  module CLT
    module Formatters
      module Helper
        def terminal_width
          @terminal_width ||= TermInfo.screen_size[1]
        end
      end
    end
  end
end
