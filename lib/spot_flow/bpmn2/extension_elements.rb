# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class ExtensionElements
      VALID_EXTENSION_NAMESPACES = %w[zeebe]

      attr_accessor :assignment_definition, :called_decision, :form_definition, :io_mapping, :properties, :script, :subscription, :task_definition, :task_schedule

      def initialize(attributes = {})
        if attributes[:properties].present?
          @properties = HashWithIndifferentAccess.new
          Array.wrap(attributes[:properties][:property]).each { |property_moddle| @properties[property_moddle[:name]] = property_moddle[:value] }
        end

        @assignment_definition = Zeebe2::AssignmentDefinition.new(attributes[:assignment_definition]) if attributes[:assignment_definition].present?
        @called_decision = Zeebe2::CalledDecision.new(attributes[:called_decision]) if attributes[:called_decision].present?
        @form_definition = Zeebe2::FormDefinition.new(attributes[:form_definition]) if attributes[:form_definition].present?
        @io_mapping = Zeebe2::IoMapping.new(attributes[:io_mapping]) if attributes[:io_mapping].present?
        @script = Zeebe2::Script.new(attributes[:script]) if attributes[:script].present?
        @subscription = Zeebe2::Subscription.new(attributes[:subscription]) if attributes[:subscription].present?
        @task_definition = Zeebe2::TaskDefinition.new(attributes[:task_definition]) if attributes[:task_definition].present?
        @task_schedule = Zeebe2::TaskSchedule.new(attributes[:task_schedule]) if attributes[:task_schedule].present?
      end
    end
  end
end
