# frozen_string_literal: true

module SpotFlow
  module Services
    class DecisionReader < ApplicationService
      DECISION_READER_BIN = File.expand_path(File.dirname(__FILE__)) + "/decision_reader.js"

      def initialize(source, env: nil)
        super()
        @source = source
        @env = env
      end

      def call
        execute_json_process(DECISION_READER_BIN, @source, env: @env)
      end
    end
  end
end
