# frozen_string_literal: true

module SpotFlow
  module Bpmn
    class Extension
      include ActiveModel::Model
    end
  end

  module Zeebe
    class AssignmentDefinition < Bpmn::Extension
      attr_accessor :assignee, :candidate_groups, :candidate_users
    end

    class CalledDecision < Bpmn::Extension
      attr_accessor :decision_id, :result_variable
    end

    class FormDefinition < Bpmn::Extension
      attr_accessor :form_key
    end

    class IoMapping < Bpmn::Extension
      def initialize(attributes = {})
        super

        @inputs = attributes[:input_parameters] || []
        @outputs = attributes[:output_parameters] || []
      end

      def inputs
        @inputs.map { |parameter_moddle| Parameter.new(parameter_moddle) }
      end

      def outputs
        @outputs.map { |parameter_moddle| Parameter.new(parameter_moddle) }
      end
    end

    class Parameter < Bpmn::Extension
      attr_accessor :source, :target
    end

    class Script < Bpmn::Extension
      attr_accessor :expression, :result_variable
    end

    class Subscription < Bpmn::Extension
      attr_accessor :correlation_key
    end

    class TaskDefinition < Bpmn::Extension
      attr_accessor :type, :retries
    end

    class TaskSchedule < Bpmn::Extension
      attr_accessor :due_date, :follow_up_date
    end
  end
end
