# frozen_string_literal: true

module SpotFlow
  module Zeebe
    class AssignmentDefinition
      attr_accessor :assignee, :candidate_groups, :candidate_users

      def initialize(moddle)
        @assignee = moddle["assignee"]
        @candidate_groups = moddle["candidateGroups"]
        @candidate_users = moddle["candidateUsers"]
      end
    end

    class CalledDecision
      attr_accessor :decision_id, :result_variable

      def initialize(moddle)
        @decision_id = moddle["decisionId"]
        @result_variable = moddle["resultVariable"]
      end
    end

    class FormDefinition
      attr_accessor :form_key

      def initialize(moddle)
        @form_key = moddle["formKey"]
      end
    end

    class IoMapping
      def initialize(moddle)
        @inputs = moddle["inputParameters"] || []
        @outputs = moddle["outputParameters"] || []
      end

      def inputs
        @inputs.map { |parameter_moddle| Parameter.new(parameter_moddle) }
      end

      def outputs
        @outputs.map { |parameter_moddle| Parameter.new(parameter_moddle) }
      end
    end

    class Parameter
      attr_accessor :source, :target

      def initialize(moddle)
        @source = moddle["source"]
        @target = moddle["target"]
      end
    end

    class Script
      attr_accessor :expression, :result_variable

      def initialize(moddle)
        @expression = moddle["expression"]
        @result_variable = moddle["resultVariable"]
      end
    end

    class Subscription
      attr_accessor :correlation_key

      def initialize(moddle)
        @correlation_key = moddle["correlationKey"]
      end
    end

    class TaskDefinition
      attr_accessor :type, :retries

      def initialize(moddle)
        @type = moddle["type"]
        @retries = moddle["retries"]
      end
    end

    class TaskSchedule
      attr_accessor :due_date, :follow_up_date

      def initialize(moddle)
        @due_date = moddle["dueDate"]
        @follow_up_date = moddle["followUpDate"]
      end
    end
  end
end
