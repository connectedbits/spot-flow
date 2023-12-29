# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Process
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :name, :is_executable
      attr_accessor :start_events, :end_events, :intermediate_throw_events, :intermediate_catch_events, :boundary_events
      attr_accessor :gateways, :exclusive_gateways, :parallel_gateways, :inclusive_gateways, :event_based_gateways
      attr_accessor :tasks, :business_rule_tasks, :script_tasks, :service_tasks, :user_tasks
      attr_accessor :sequence_flows

      def attributes
        {
          "id": nil,
          "name": nil,
          "is_executable": nil,
        }
      end
    end
  end
end
