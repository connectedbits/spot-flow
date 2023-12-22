# frozen_string_literal: true

module SpotFlow
  module Services
    class JsonLogicEvaluator
      attr_reader :expression, :variables

      def self.call(expression:, variables:)
        new(expression: expression, variables: variables).call
      end

      def initialize(expression:, variables: {})
        super()
        @expression = expression
        @variables = variables
      end

      def call
        JSONLogic.apply(JSON.parse(expression).deep_stringify_keys, variables.deep_stringify_keys)
      end
    end
  end
end
