# frozen_string_literal: true

module SpotFlow
  module Bpmn
    module ProcessBehavior
      attr_accessor :is_executable

      attr_accessor :start_events, :end_events, :intermediate_catch_events, :intermediate_throw_events, :boundary_events
      attr_accessor :tasks, :user_tasks, :service_tasks, :script_tasks, :send_tasks, :receive_tasks, :manual_tasks, :business_rule_tasks, :call_activities
      attr_accessor :sub_processes, :ad_hoc_sub_processes
      attr_accessor :sequence_flows, :message_flows, :associations, :data_associations, :data_inputs, :data_outputs
      attr_accessor :data_objects, :data_stores, :data_stores_references
      attr_accessor :gateways, :exclusive_gateways, :parallel_gateways, :inclusive_gateways, :event_based_gateways, :complex_gateways

      attr_accessor :parent

      def elements
        @elements ||= {}.tap do |elements|
          elements.merge!(start_events.index_by(&:id))
          elements.merge!(end_events.index_by(&:id))
          elements.merge!(intermediate_catch_events.index_by(&:id))
          elements.merge!(intermediate_throw_events.index_by(&:id))
          elements.merge!(boundary_events.index_by(&:id))
          elements.merge!(tasks.index_by(&:id))
          elements.merge!(user_tasks.index_by(&:id))
          elements.merge!(service_tasks.index_by(&:id))
          elements.merge!(script_tasks.index_by(&:id))
          elements.merge!(business_rule_tasks.index_by(&:id))
          elements.merge!(call_activities.index_by(&:id))
          elements.merge!(sub_processes.index_by(&:id))
          elements.merge!(ad_hoc_sub_processes.index_by(&:id))
          elements.merge!(exclusive_gateways.index_by(&:id))
          elements.merge!(parallel_gateways.index_by(&:id))
          elements.merge!(inclusive_gateways.index_by(&:id))
          elements.merge!(event_based_gateways.index_by(&:id))
          elements.merge!(sequence_flows.index_by(&:id))
        end
      end

      def wire_references(definitions)
        elements.values.each do |element|
          if element.is_a?(Step)
            element.incoming = element.incoming.map { |id| element_by_id(id) }
            element.outgoing = element.outgoing.map { |id| element_by_id(id) }

            if element.is_a?(Event)
              element.event_definitions.each do |event_definition|
                case event_definition.class
                when Bpmn::MessageEventDefinition
                  event_definition.message = element.element_by_id(definitions.message_by_id(event_definition.message_ref))
                when Bpmn::SignalEventDefinition
                  event_definition.signal = element.element_by_id(definitions.signal_by_id(event_definition.signal_ref))
                when Bpmn::ErrorEventDefinition
                  event_definition.error = element.element_by_id(definitions.error_by_id(event_definition.error_ref))
                end
              end
            end
            if element.is_a?(Gateway)
              # TODO: is this right?
              #element.default = element.element_by_id(element.default_ref)
            end
          elsif element.is_a?(SequenceFlow)
            element.source = element_by_id(element.source_ref)
            element.target = element_by_id(element.target_ref)
          end

          # Not handled participant process ref
        end
      end

      def element_by_id(id)
        elements[id]
      end

      def elements_by_type(type)
        elements.select { |e| e.class == type }
      end

      def default_start_event
        start_events.find { |se| se.event_definitions.empty? }
      end

      def execute(execution)
        start_event = execution.start_event_id ? element_by_id(execution.start_event_id) : default_start_event
        raise ExecutionErrorNew.new("Process must have at least one start event.") if start_event.blank?
        execution.execute_step(start_event)
      end
    end

    class Process < Step
      include ProcessBehavior

      def initialize(attributes = {})
        super(attributes.slice(:id, :name, :extension_elements, :incoming, :outgoing, :default))

        @is_executable = attributes[:is_executable] == ("true" || true)

        @start_events = Array.wrap(attributes[:start_event]).map { |se| StartEvent.new(se) }
        @end_events = Array.wrap(attributes[:end_event]).map { |ee| EndEvent.new(ee) }
        @intermediate_catch_events = Array.wrap(attributes[:intermediate_catch_event]).map { |ice| IntermediateCatchEvent.new(ice) }
        @intermediate_throw_events = Array.wrap(attributes[:intermediate_throw_event]).map { |ite| IntermediateThrowEvent.new(ite) }
        @boundary_events = Array.wrap(attributes[:boundary_event]).map { |be| BoundaryEvent.new(be) }
        @tasks = Array.wrap(attributes[:task]).map { |t| Task.new(t) }
        @user_tasks = Array.wrap(attributes[:user_task]).map { |ut| UserTask.new(ut) }
        @service_tasks = Array.wrap(attributes[:service_task]).map { |st| ServiceTask.new(st) }
        @script_tasks = Array.wrap(attributes[:script_task]).map { |st| ScriptTask.new(st) }
        @business_rule_tasks = Array.wrap(attributes[:business_rule_task]).map { |brt| BusinessRuleTask.new(brt) }
        @call_activities = Array.wrap(attributes[:call_activitie]).map { |ca| CallActivity.new(ca) }
        @sub_processes = Array.wrap(attributes[:sub_processe]).map { |sp| SubProcess.new(sp) }
        @ad_hoc_sub_processes = Array.wrap(attributes[:ad_hoc_sub_processe]).map { |ahsp| AdHocSubProcess.new(ahsp) }
        @exclusive_gateways = Array.wrap(attributes[:exclusive_gateway]).map { |eg| ExclusiveGateway.new(eg) }
        @parallel_gateways = Array.wrap(attributes[:parallel_gateway]).map { |pg| ParallelGateway.new(pg) }
        @inclusive_gateways = Array.wrap(attributes[:inclusive_gateway]).map { |ig| InclusiveGateway.new(ig) }
        @event_based_gateways = Array.wrap(attributes[:event_based_gateway]).map { |ebg| EventBasedGateway.new(ebg) }
        @sub_processes = Array.wrap(attributes[:sub_processe]).map { |sp| SubProcess.new(sp) }
        @sequence_flows = Array.wrap(attributes[:sequence_flow]).map { |sf| SequenceFlow.new(sf) }
      end
    end

    class SubProcess < Activity
      include ProcessBehavior

      attr_accessor :triggered_by_event

      def initialize(attributes = {})
        super(attributes.except(:triggered_by_event))

        @is_executable = false
        @sub_processes = []
        @triggered_by_event = attributes[:triggered_by_event]
      end

      def execution_ended(execution)
        leave(execution)
      end
    end

    class AdHocSubProcess < SubProcess

    end

    class CallActivity < Activity
      attr_accessor :called_element, :process_ref

      def initialize(attributes = {})
        super(attributes.except(:called_element, :process_ref))

        @called_element = attributes[:called_element]
        @process_ref = attributes[:process_ref]
      end

      def execute(execution)
        if SpotFeel::Dmn::LiteralExpression.valid?(called_element)
          process_id = SpotFeel::Dmn::LiteralExpression.new(expression).evaluate(execution.variables)
        else
          process_id = called_element
        end
        execution.call(process_id)
      end
    end
  end
end
