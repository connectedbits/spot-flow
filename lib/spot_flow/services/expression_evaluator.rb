# frozen_string_literal: true

module SpotFlow
  module Services
    class ExpressionEvaluator

      attr_reader :expression, :variables

      def self.call(expression:, variables: {})
        new(expression: expression, variables: variables).call
      end

      def initialize(expression:, variables: {})
        super()
        @expression = expression.strip
        @variables = variables
      end

      def call
        json_logic? ? call_json_logic : call_feel
      end

      def call_feel
        FeelEvaluator.call(expression: expression.delete_prefix("=").strip, variables: variables)
      end

      def call_json_logic
        JsonLogicEvaluator.call(expression: expression, variables: variables)
      end

      def feel?
        expression.start_with?("=")
      end

      def json_logic?
        expression.start_with?("{") && expression.end_with?("}")
      end
    end
  end
end
