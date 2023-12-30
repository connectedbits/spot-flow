# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Definitions
      include ActiveModel::Model

      attr_accessor :id, :name, :target_namespace, :exporter, :exporter_version, :execution_platform, :execution_platform_version
      attr_accessor :elements, :processes, :messages, :signals, :errors

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

          definitions.messages = Array.wrap(moddle[:message]).map do |message_moddle|
            Message.new(message_moddle.slice(:id, :name)).tap do |element|
              definitions.elements[element.id] = element
            end
          end

          definitions.signals = Array.wrap(moddle[:signal]).map do |signal_moddle|
            Signal.new(signal_moddle.slice(:id, :name)).tap do |element|
              definitions.elements[element.id] = element
            end
          end

          definitions.errors = Array.wrap(moddle[:signal]).map do |error_moddle|
            Error.new(error_moddle.slice(:id, :name)).tap do |element|
              definitions.elements[element.id] = element
            end
          end

          definitions.processes = Array.wrap(moddle[:process]).map do |process_moddle|
            Process.new(process_moddle.slice(:id, :name)).tap do |process|
              process.is_executable = process_moddle[:is_executable] == "true"
              definitions.elements[process.id] = process

              process.start_events = Array.wrap(process_moddle[:start_event]).map do |element_moddle|
                StartEvent.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  event_from_moddle(element_moddle, element)
                end
              end

              process.end_events = Array.wrap(process_moddle[:end_event]).map do |element_moddle|
                EndEvent.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  event_from_moddle(element_moddle, element)
                end
              end

              process.boundary_events = Array.wrap(process_moddle[:boundary_event]).map do |element_moddle|
                BoundaryEvent.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  event_from_moddle(element_moddle, element)
                end
              end

              process.intermediate_catch_events = Array.wrap(process_moddle[:intermediate_catch_event]).map do |element_moddle|
                IntermediateCatchEvent.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  event_from_moddle(element_moddle, element)
                end
              end

              process.intermediate_throw_events = Array.wrap(process_moddle[:intermediate_throw_event]).map do |element_moddle| 
                IntermediateThrowEvent.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  event_from_moddle(element_moddle, element)
                end
              end

              process.tasks = Array.wrap(process_moddle[:task]).map do |element_moddle|
                Task.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.business_rule_tasks = Array.wrap(process_moddle[:business_rule_task]).map do |element_moddle|
                BusinessRuleTask.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.script_tasks = Array.wrap(process_moddle[:script_task]).map do |element_moddle|
                ScriptTask.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.service_tasks = Array.wrap(process_moddle[:service_task]).map do |element_moddle|
                ServiceTask.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.user_tasks = Array.wrap(process_moddle[:user_task]).map do |element_moddle|
                UserTask.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.exclusive_gateways = Array.wrap(process_moddle[:execlusive_gateway]).map do |element_moddle|
                ExclusiveGateway.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.parallel_gateways = Array.wrap(process_moddle[:parallel_gateway]).map do |element_moddle|
                ParallelGateway.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.inclusive_gateways = Array.wrap(process_moddle[:inclusive_gateway]).map do |element_moddle|
                InclusiveGateway.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.event_based_gateways = Array.wrap(process_moddle[:event_based_gateway]).map do |element_moddle|
                EventBasedGateway.new(element_moddle.slice(:id, :name)).tap do |element|
                  definitions.elements[element.id] = element
                  step_from_moddle(element_moddle, element)
                end
              end

              process.sequence_flows = Array.wrap(process_moddle[:sequence_flow]).map do |element_moddle|
                SequenceFlow.new(element_moddle.slice(:id, :source_ref, :target_ref)).tap do |element|
                  definitions.elements[element.id] = element
                  element.condition_expression = moddle[:condition_expression] if moddle[:condition_expression]
                end
              end
            end
          end

          wire_references(definitions)
        end
      end

      def initialize(attributes={})
        super
        @elements ||= {}
      end

      def process_by_id(id)
        processes.find { |process| process.id == id }
      end

      def element_by_id(id)
        elements[id]
      end

      #
      # Moddle builders
      #

      def self.event_from_moddle(moddle, event)
        step_from_moddle(moddle, event)
        event.conditional_event_definition = ConditionalEventDefinition.new(moddle[:conditional_event_definition]) if moddle[:conditional_event_definition]
        event.escalation_event_definition = EscalationEventDefinition.new(moddle[:escalation_event_definition]) if moddle[:escalation_event_definition]
        event.error_event_definition = ErrorEventDefinition.new(moddle[:error_event_definition]) if moddle[:error_event_definition]
        event.message_event_definition = MessageEventDefinition.new(moddle[:message_event_definition]) if moddle[:message_event_definition]
        event.signal_event_definition = SignalEventDefinition.new(moddle[:signal_event_definition]) if moddle[:signal_event_definition]
        event.terminate_event_definition = TerminateEventDefinition.new(moddle[:terminate_event_definition]) if moddle[:terminate_event_definition]
        event.timer_event_definition = TimerEventDefinition.new(moddle[:timer_event_definition]) if moddle[:timer_event_definition]
      end

      def self.step_from_moddle(moddle, step)
        step.incoming = Array.wrap(moddle[:incoming]) if moddle[:incoming]
        step.outgoing = Array.wrap(moddle[:outgoing]) if moddle[:outgoing]
        step.extension_elements = ExtensionElements.new do |extension_elements|
          # TODO: create extension elements
        end if moddle[:extension_elements]
        step.default = moddle[:default] if moddle[:default]
      end

      #
      # After creating all elements, wire up references
      #
      def self.wire_references(definitions)
        elements = definitions.elements
        elements.values.each do |element|
          if element.is_a?(BoundaryEvent)
            element.attached_to = elements[element.attached_to_ref] if element.attached_to_ref
            element.attachments = element.attachments.map { |attachment_id| elements[attachment_id] } if element.is_a?(Activity)
          end

          if element.is_a?(EventDefinition)
            element.message = elements[element.message_ref] if element.message_ref
            element.signal = elements[element.signal_ref] if element.signal_ref
            element.error = elements[element.error_ref] if element.error_ref
          end

          if element.is_a?(Event)
            # element.attached_to = elements[element.attached_to_ref] if element.attached_to_ref
            # element.attachments = element.attachments.map { |attachment_id| elements[attachment_id] }
          end

          if element.is_a?(Flow)
            element.source = elements[element.source_ref] if element.source_ref
            element.target = elements[element.target_ref] if element.target_ref
          end

          if element.is_a?(Gateway) && element.default
            element.default = elements[element.default]
          end

          if element.is_a?(Participant)
            element.process = process_by_id(element.process_ref)
          end

          if element.is_a?(Step)
            element.incoming = element.incoming.map { |incoming_id| elements[incoming_id] }
            element.outgoing = element.outgoing.map { |outgoing_id| elements[outgoing_id] }
          end
        end
      end
    end
  end
end
