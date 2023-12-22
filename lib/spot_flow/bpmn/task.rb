# frozen_string_literal: true

module SpotFlow
  module Bpmn
    class Task < Activity

      def is_automated?
        false
      end

      def is_manual?
        true
      end

      def execute(execution)
        execution.wait
      end

      def signal(execution)
        leave(execution)
      end

      def result_to_variables(result)
        if result_variable
          return { "#{result_variable}": result }
        else
          if result.is_a? Hash
            result
          else
            {}.tap { |h| h[id.underscore] = result }
          end
        end
      end
    end

    class UserTask < Task

      def form_key
        extension_elements&.form_definition&.form_key
      end
    end

    class ServiceTask < Task
      attr_accessor :service

      def is_automated?
        true
      end

      def is_manual?
        false
      end

      def execute(execution)
        execution.wait
      end

      def service_key
        extension_elements&.task_definition&.type
      end
    end

    class ScriptTask < ServiceTask

      def script
        extension_elements&.script&.expression
      end

      def result_variable
        extension_elements&.script&.result_variable
      end
    end

    class BusinessRuleTask < ServiceTask

      def decision_id
        extension_elements&.called_decision&.decision_id
      end

      def result_variable
        extension_elements&.called_decision&.result_variable
      end
    end
  end
end
