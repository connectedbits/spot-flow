# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Flow < Element
      include ActiveModel::Model

      attr_accessor :source_ref, :target_ref
      attr_accessor :source, :target
    end

    class SequenceFlow < Flow
      attr_accessor :condition_expression

      def attributes
        super.attributes.merge(
          {
            "condition_expression": nil,
          },
        )
      end

      def evaluate(execution)
        return true unless condition&.body
        execution.evaluate_condition(condition_expression)
      end
    end

    class TextAnnotation < Flow
    end
  end
end
