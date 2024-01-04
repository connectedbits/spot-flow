# frozen_string_literal: true

module SpotFlow
  module Bpmn
    class ExtensionElements
      VALID_EXTENSION_NAMESPACES = %w[zeebe]

      attr_accessor :assignment_definition, :called_decision, :form_definition, :io_mapping, :properties, :script, :subscription, :task_definition, :task_schedule

      def initialize(moddle)
        moddle["values"].each do |moddle_value|
          extension_type = moddle_value["$type"]
          if extension_type == "zeebe:Properties"
            @properties = {}
            moddle_value["properties"].each { |property_moddle| @properties[property_moddle["name"]] = property_moddle["value"] } if moddle_value["properties"].present?
          else
            extension_parts = extension_type.split(":")
            namespace = extension_parts.first
            raise "Unsupported extension namespace: #{namespace}" unless VALID_EXTENSION_NAMESPACES.include?(namespace)
            if klass = "SpotFlow::#{extension_parts.first.capitalize}::#{extension_parts.last}".safe_constantize
              send("#{extension_parts.last.underscore}=", klass.new(moddle_value))
            else
              raise "Unknown extension type: #{extension_type}"
            end
          end
        end
      end
    end
  end
end
