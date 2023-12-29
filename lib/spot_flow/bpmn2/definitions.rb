# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Definitions
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :name, :target_namespace, :exporter, :exporter_version, :execution_platform, :execution_platform_version, :processes

      def self.from_xml(xml)
        XmlHasher.configure do |config|
          config.snakecase = true
          config.ignore_namespaces = true
          config.string_keys = false
        end
        hash = XmlHasher.parse(xml)
        from_moddle(hash[:definitions])
      end

      def self.from_moddle(moddle)
        Definitions.new(moddle.slice(:id, :name, :target_namespace, :exporter, :exporter_version, :execution_platform, :execution_platform_version)).tap do |definitions|
          definitions.processes = Array.wrap(moddle[:process]).map { |process_moddle| process_from_moddle(process_moddle) }
        end
      end

      def attributes
        {
          "id": nil,
          "name": nil,
          "target_namespace": nil,
          "exporter": nil,
          "exporter_version": nil,
          "execution_platform": nil,
          "execution_platform_version": nil,
          "processes": [],
        }
      end

      #
      # Moddle builders
      #

      def self.process_from_moddle(moddle)
        Process.new(moddle.slice(:id, :name)).tap do |process|
          process.is_executable = moddle[:is_executable] == "true"
          process.start_events = Array.wrap(moddle[:start_event]).map { |event_moddle| event_from_moddle(event_moddle, StartEvent) }
          process.end_events = Array.wrap(moddle[:end_event]).map { |event_moddle| event_from_moddle(event_moddle, EndEvent) }
          process.boundary_events = Array.wrap(moddle[:boundary_event]).map { |event_moddle| event_from_moddle(event_moddle, BoundaryEvent) }
          process.intermediate_catch_events = Array.wrap(moddle[:intermediate_catch_event]).map { |event_moddle| event_from_moddle(event_moddle, IntermediateCatchEvent) }
          process.intermediate_throw_events = Array.wrap(moddle[:intermediate_throw_event]).map { |event_moddle| event_from_moddle(event_moddle, IntermediateThrowEvent) }
          process.tasks = Array.wrap(moddle[:task]).map { |task_moddle| task_from_moddle(task_moddle, Task) }
          process.business_rule_tasks = Array.wrap(moddle[:business_rule_task]).map { |task_moddle| task_from_moddle(task_moddle, BusinessRuleTask) }
          process.script_tasks = Array.wrap(moddle[:script_task]).map { |task_moddle| task_from_moddle(task_moddle, ScriptTask) }
          process.service_tasks = Array.wrap(moddle[:service_task]).map { |task_moddle| task_from_moddle(task_moddle, ServiceTask) }
          process.user_tasks = Array.wrap(moddle[:user_task]).map { |task_moddle| task_from_moddle(task_moddle, UserTask) }
          process.exclusive_gateways = Array.wrap(moddle[:exclusive_gateway]).map { |gateway_moddle| gateway_from_moddle(gateway_moddle, ExclusiveGateway) }
          process.parallel_gateways = Array.wrap(moddle[:parallel_gateway]).map { |gateway_moddle| gateway_from_moddle(gateway_moddle, ParallelGateway) }
          process.inclusive_gateways = Array.wrap(moddle[:inclusive_gateway]).map { |gateway_moddle| gateway_from_moddle(gateway_moddle, InclusiveGateway) }
          process.event_based_gateways = Array.wrap(moddle[:event_based_gateway]).map { |gateway_moddle| gateway_from_moddle(gateway_moddle, EventBasedGateway) }
          process.sequence_flows = Array.wrap(moddle[:sequence_flow]).map { |flow_moddle| flow_from_moddle(flow_moddle, SequenceFlow) }
        end
      end

      def self.extensions_elements_from_moddle(_moddle)
        ExtensionElements.new.tap do |extension_elements|
        end
      end

      def self.event_from_moddle(moddle, type)
        type.new(moddle.slice(:id, :name)).tap do |event|
          self.step_from_moddle(moddle, event)
          event.conditional_event_definition = ConditionalEventDefinition.new(moddle[:conditional_event_definition]) if moddle[:conditional_event_definition]
          event.escalation_event_definition = EscalationEventDefinition.new(moddle[:escalation_event_definition]) if moddle[:escalation_event_definition]
          event.error_event_definition = ErrorEventDefinition.new(moddle[:error_event_definition]) if moddle[:error_event_definition]
          event.message_event_definition = MessageEventDefinition.new(moddle[:message_event_definition]) if moddle[:message_event_definition]
          event.signal_event_definition = SignalEventDefinition.new(moddle[:signal_event_definition]) if moddle[:signal_event_definition]
          event.terminate_event_definition = TerminateEventDefinition.new(moddle[:terminate_event_definition]) if moddle[:terminate_event_definition]
          event.timer_event_definition = TimerEventDefinition.new(moddle[:timer_event_definition]) if moddle[:timer_event_definition]
        end
      end

      def self.gateway_from_moddle(moddle, type)
        type.new(moddle.slice(:id, :name)).tap do |gateway|
          self.step_from_moddle(moddle, gateway)
        end
      end

      def self.task_from_moddle(moddle, type)
        type.new(moddle.slice(:id, :name)).tap do |task|
          self.step_from_moddle(moddle, task)
        end
      end

      def self.step_from_moddle(moddle, instance)
        instance.incoming = Array.wrap(moddle[:incoming]) if moddle[:incoming]
        instance.outgoing = Array.wrap(moddle[:outgoing]) if moddle[:outgoing]
        instance.extension_elements = extensions_elements_from_moddle(moddle[:extension_elements]) if moddle[:extension_elements]
      end

      def self.flow_from_moddle(moddle, type)
        type.new(moddle.slice(:id, :source_ref, :target_ref)).tap do |flow|
          flow.condition_expression = moddle[:condition_expression] if moddle[:condition_expression]
        end
      end
    end
  end
end
