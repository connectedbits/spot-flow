# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Expression < Element
      attr_accessor :body, :language

      def initialize(moddle)
        super
        @body = moddle["body"]
        @language = moddle["language"]
      end

      def valid?
        str&.start_with?("=")
      end

      def self.valid?(str)
        str&.start_with?("=")
      end
    end

    class ConditionExpression < Expression
    end
  end
end
