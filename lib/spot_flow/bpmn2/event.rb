# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Event < Step
      attr_accessor :conditional_event_definition, :escalation_event_definition, :error_event_definition, :message_event_definition, :signal_event_definition, :terminate_event_definition, :timer_event_definition

      def attributes
        super.attributes.merge({
          "conditional_event_definition": nil,
          "escalation_event_definition": nil,
          "error_event_definition": nil,
          "message_event_definition": nil,
          "signal_event_definition": nil,
          "terminate_event_definition": nil,
          "timer_event_definition": nil,
        })
      end
    end

    class StartEvent < Event
    end

    class IntermediateThrowEvent < Event
    end

    class IntermediateCatchEvent < Event
    end

    class BoundaryEvent < Event
    end

    class EndEvent < Event
    end
  end
end
