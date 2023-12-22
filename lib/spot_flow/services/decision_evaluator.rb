# frozen_string_literal: true

module SpotFlow
  module Services
    class DecisionEvaluator < ApplicationService
      EVALUATE_BIN = File.expand_path(File.dirname(__FILE__)) + "/decision_evaluator.js"

      def initialize(decision_id, source, context, functions: [], env: nil)
        super()
        @decision_id = decision_id
        @source = source
        @context = context
        @functions = functions
        @env = env
      end

      def call
        execute_json_process(EVALUATE_BIN, @decision_id, @source, @context.to_json, *@functions, env: @env)
      end
    end
  end
end
