# frozen_string_literal: true

require_relative "./process_executor"

module SpotFlow
  module Services
    class FeelEvaluator
      include ProcessExecutor

      FEEL_EVALUATOR_BIN = File.expand_path(File.dirname(__FILE__)) + "/feel_evaluator.js"

      attr_reader :expression, :variables, :functions

      def self.call(expression:, variables:, functions: [])
        new(expression: expression, variables: variables, functions: functions).call
      end

      def initialize(expression:, variables: {}, functions: [], env: nil)
        super()
        @expression = expression
        @variables = variables
        @functions = functions
        @env = env
      end

      def call
        result = execute_process(FEEL_EVALUATOR_BIN, expression, variables.to_json, *functions, env: @env)
        JSON.parse(result)
      rescue JSON::ParserError
        result.strip
      end
    end
  end
end
