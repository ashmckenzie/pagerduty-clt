module Pagerduty
  module CLT
    class Node

      attr_reader :name

      def initialize(name)
        @name = name
      end

    end

    NullNode = Naught.build do |config|
      config.mimic Node
    end
  end
end
