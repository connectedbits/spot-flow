# frozen_string_literal: true

module SpotFlow
  module Bpmn
    class Expression < Element
      attr_accessor :body, :language

      def initialize(moddle)
        super
        @body = moddle["body"]
        @language = moddle["language"]
      end

      def valid?
        feel? || json_logic?
      end

      def feel?
        Expression.feel?(body)
      end

      def json_logic?
        Expression.json_logic?(body)
      end

      def self.feel?(str)
        str&.start_with?("=")
      end

      def self.json_logic?(str)
        str&.start_with?("{") && str&.end_with?("}")
      end

      def self.valid?(str)
        Expression.feel?(str) || Expression.json_logic?(str)
      end
    end

    class ConditionExpression < Expression

    end
  end
end
