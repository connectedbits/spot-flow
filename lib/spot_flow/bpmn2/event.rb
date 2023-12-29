# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Event < Step
      attr_accessor :conditional_event_definition, :escalation_event_definition, :error_event_definition, :message_event_definition, :signal_event_definition, :terminate_event_definition, :timer_event_definition
    end

    class StartEvent < Event
    end

    class IntermediateThrowEvent < Event
    end

    class IntermediateCatchEvent < Event
    end

    class BoundaryEvent < Event
      attr_accessor :attached_to_ref, :attached_to, :cancel_activity
    end

    class EndEvent < Event
    end
  end
end
