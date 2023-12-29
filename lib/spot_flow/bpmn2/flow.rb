# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Flow
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :source_ref, :target_ref

      def attributes
        {
          "id": nil,
          "source_ref": nil,
          "target_ref": nil,
        }
      end
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
    end
  end
end
