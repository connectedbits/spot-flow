# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class ExtensionElements
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :assignment_definition, :called_decision, :form_definition, :io_mapping, :properties, :script, :subscription, :task_definition, :task_schedule

      def self.from_moddle(_moddle)
        ExtensionElements.new
      end
    end
  end
end
