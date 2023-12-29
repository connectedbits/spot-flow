# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Task < Step
      include ActiveModel::Model
      include ActiveModel::Serialization
    end

    class UserTask < Task
    end

    class ServiceTask < Task
    end

    class ScriptTask < ServiceTask
    end

    class BusinessRuleTask < ServiceTask
    end
  end
end
