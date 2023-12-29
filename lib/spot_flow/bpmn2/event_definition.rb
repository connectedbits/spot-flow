# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class EventDefinition
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id

      def attributes
        {
          "id": nil,
        }
      end
    end

    class ConditionalEventDefinition < EventDefinition
    end

    class EscalationEventDefinition < EventDefinition
    end

    class ErrorEventDefinition < EventDefinition
    end

    class MessageEventDefinition < EventDefinition
      attr_accessor :message_ref, :message

      def attributes
        {
          "id": nil,
          "message_ref": nil,
        }
      end
    end

    class SignalEventDefinition < EventDefinition
    end

    class TimerEventDefinition < EventDefinition
      attr_accessor :time_date, :time_duration_type, :time_duration, :time_cycle

      def attributes
        {
          "id": nil,
          "time_date": nil,
          "time_duration_type": nil,
          "time_duration": nil,
          "time_cycle": nil,
        }
      end
    end
  end
end
