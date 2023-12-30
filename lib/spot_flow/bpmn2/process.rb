# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Process
      include ActiveModel::Model

      attr_accessor :id, :name, :is_executable
      attr_accessor :start_events, :end_events, :intermediate_throw_events, :intermediate_catch_events, :boundary_events
      attr_accessor :exclusive_gateways, :parallel_gateways, :inclusive_gateways, :event_based_gateways
      attr_accessor :tasks, :business_rule_tasks, :script_tasks, :service_tasks, :user_tasks
      attr_accessor :sequence_flows

      def events
        @events ||= start_events + end_events + boundary_events + intermediate_catch_events + intermediate_throw_events
      end

      def gateways
        @gateways ||= exclusive_gateways + parallel_gateways + inclusive_gateways + event_based_gateways
      end

      def activities
        @activities ||= tasks + business_rule_tasks + script_tasks + service_tasks + user_tasks
      end

      def steps
        @steps ||= activities + events + gateways
      end

      def flows
        @flows ||= sequence_flows
      end

      def elements
        @elements ||= events + gateways + tasks + flows
      end

      def element_by_id(id)
        elements.find { |e| e.id == id }
      end
    end
  end
end
