# frozen_string_literal: true

require "spot_flow/version"

require "active_support"
require "active_support/time"
require "active_support/core_ext/hash"
require "active_support/core_ext/object/json"
require "json_logic"
require "awesome_print"

require "spot_flow/bpmn/element"
require "spot_flow/bpmn/step"
require "spot_flow/bpmn/flow"
require "spot_flow/bpmn/association"
require "spot_flow/bpmn/task"
require "spot_flow/bpmn/event"
require "spot_flow/bpmn/extensions"
require "spot_flow/bpmn/extension_elements"
require "spot_flow/bpmn/gateway"
require "spot_flow/bpmn/builder"
require "spot_flow/bpmn/process"
require "spot_flow/bpmn/expression"
require "spot_flow/bpmn/event_definition"
require "spot_flow/bpmn/text_annotation"

require "spot_flow/context"
require "spot_flow/execution"
require "spot_flow/task_runner"

require "spot_flow/services/application_service"
require "spot_flow/services/decision_evaluator"
require "spot_flow/services/decision_reader"
require "spot_flow/services/expression_evaluator"
require "spot_flow/services/feel_evaluator"
require "spot_flow/services/json_logic_evaluator"
require "spot_flow/services/process_reader"
require "spot_flow/services/script_runner"

module SpotFlow
  #
  # Entry point for starting a process execution.
  #
  # sources: Single or array of BPMN or DMN XML sources
  # services: Hash of procs to be injected into the context
  #
  def self.new(sources, services: {}, listeners: [])
    Context.new(sources: Array.wrap(sources), services: services, listeners: listeners)
  end
end
