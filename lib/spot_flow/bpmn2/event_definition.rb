# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class EventDefinition < Element
      def execute(execution)
      end
    end

    class ConditionalEventDefinition < EventDefinition
      attr_accessor :variable_name, :variable_events, :condition
    end

    class EscalationEventDefinition < EventDefinition
    end

    class ErrorEventDefinition < EventDefinition
      attr_accessor :error_ref, :error
      attr_accessor :error_code_variable, :error_message_variable
    end

    class MessageEventDefinition < EventDefinition
      attr_accessor :message_ref, :message
    end

    class SignalEventDefinition < EventDefinition
      attr_accessor :signal_ref, :signal
    end

    class TerminateEventDefinition < EventDefinition
    end

    class TimerEventDefinition < EventDefinition
      attr_accessor :time_date, :time_duration_type, :time_duration, :time_cycle
    end
  end
end
