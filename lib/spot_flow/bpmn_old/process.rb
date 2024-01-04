# frozen_string_literal: true

module SpotFlow
  module Bpmn
    module ProcessBehavior
      attr_accessor :is_executable
      attr_accessor :elements, :parent
      attr_accessor :sub_processes

      def element_by_id(id)
        elements.find { |e| e.id == id }
      end

      def elements_by_type(type)
        elements.select { |e| e.type == type }
      end

      def start_events
        elements_by_type("bpmn:StartEvent")
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

      def initialize(moddle)
        super

        @is_executable = moddle["isExecutable"]
        @elements = []
        @sub_processes = []
      end
    end

    class SubProcess < Activity
      include ProcessBehavior

      attr_accessor :triggered_by_event

      def initialize(moddle)
        super

        @is_executable = false
        @elements = []
        @sub_processes = []
        @triggered_by_event = moddle["triggeredByEvent"]
      end

      def execution_ended(execution)
        leave(execution)
      end
    end

    class AdHocSubProcess < SubProcess

    end

    class CallActivity < Activity
      attr_accessor :called_element, :process_ref

      def initialize(moddle)
        super
        @called_element = moddle["calledElement"]
        @process_ref = moddle["processRef"]
      end

      def execute(execution)
        if Bpmn::Expression.valid?(called_element)
          process_id = execution.evaluate_expression(expression)
        else
          process_id = called_element
        end
        execution.call(process_id)
      end
    end
  end
end
