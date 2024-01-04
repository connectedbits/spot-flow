# frozen_string_literal: true

module SpotFlow
  module Bpmn
    class EventDefinition < Element

      def execute(execution)
      end
    end

    class ConditionalEventDefinition < EventDefinition
      attr_accessor :variable_name, :variable_events, :condition

      def initialize(moddle)
        super
        @variable_name = moddle["variableName"] # "var1"
        @variable_events = moddle["variableEvents"] # "create, update"
        @condition = Bpmn::Expression.new(moddle["condition"]) if moddle["condition"] # ${var1 == 1}
      end
    end

    class EscalationEventDefinition < EventDefinition
    end

    class ErrorEventDefinition < EventDefinition
      attr_accessor :error_ref, :error
      attr_accessor :error_code_variable, :error_message_variable

      def initialize(moddle)
        super
        @error_ref = moddle["errorRef"]
        @error_code_variable = moddle["errorCodeVariable"]
        @error_message_variable = moddle["errorMessageVariable"]
      end

      def execute(execution)
        if execution.step.is_throwing?
          execution.throw_error(error_name)
        else
          execution.error_names.push error_name
        end
      end

      def error_id
        error&.id
      end

      def error_name
        error&.name
      end
    end

    class MessageEventDefinition < EventDefinition
      attr_accessor :message_ref, :message

      def initialize(moddle)
        super
        @message_ref = moddle["messageRef"]
      end

      def execute(execution)
        if execution.step.is_throwing?
          execution.throw_message(message_name)
        else
          execution.message_names.push message_name
        end
      end

      def message_id
        message&.id
      end

      def message_name
        message&.name
      end
    end

    class SignalEventDefinition < EventDefinition
      attr_accessor :signal_ref, :signal

      def initialize(moddle)
        super
        @signal_ref = moddle["signalRef"]
      end

      def signal_id
        signal&.id
      end

      def signal_name
        signal&.name
      end
    end

    class TerminateEventDefinition < EventDefinition

      def execute(execution)
        execution.parent&.terminate
      end
    end

    class TimerEventDefinition < EventDefinition
      attr_accessor :time_date, :time_duration_type, :time_duration, :time_cycle

      def initialize(moddle)
        super
        if moddle["timeDuration"]
          @time_duration_type = moddle["timeDuration"]["$type"]
          @time_duration = moddle["timeDuration"]["body"]
        end
      end

      def execute(execution)
        if execution.step.is_catching?
          execution.timer_expires_at = time_due
        end
      end

      private

      def time_due
        # Return the next time the timer is due
        if time_date
          return Date.parse(time_date)
        elsif time_duration
          return Time.zone.now + ActiveSupport::Duration.parse(time_duration)
        else
          return Time.zone.now # time_cycle not yet implemented
        end
      end
    end
  end
end
