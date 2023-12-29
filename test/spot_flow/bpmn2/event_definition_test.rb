# frozen_string_literal: true

require "test_helper"

module SpotFlow
  module Bpmn2
    describe ErrorEventDefinition do
      let(:xml) { fixture_source("error_event_definition_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("ErrorEventDefinitionTest") }
        let(:start_event) { process.element_by_id("Start") }
        let(:service_task) { process.element_by_id("ServiceTask") }
        let(:error_event) { process.element_by_id("Error") }
        let(:end_event) { process.element_by_id("End") }
        let(:end_failed_event) { process.element_by_id("EndFailed") }

        it "should parse the terminate end event" do
          _(error_event.error_event_definition.present?).must_equal true
        end
      end

      describe :execution do
      end
    end

    describe MessageEventDefinition do
      let(:xml) { fixture_source("message_event_definition_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("MessageEventDefinitionTest") }
        let(:start_event) { process.element_by_id("Start") }
        let(:catch_event) { process.element_by_id("Catch") }
        let(:host_task) { process.element_by_id("HostTask") }
        let(:boundary_event) { process.element_by_id("Boundary") }
        let(:throw_event) { process.element_by_id("Throw") }
        let(:end_event) { process.element_by_id("End") }

        it "should parse the terminate end event" do
          _(start_event.message_event_definition.present?).must_equal true
          _(catch_event.message_event_definition.present?).must_equal true
          _(boundary_event.message_event_definition.present?).must_equal true
          _(throw_event.message_event_definition.present?).must_equal true
          _(end_event.message_event_definition.present?).must_equal true
        end
      end

      describe :execution do
      end
    end

    describe TerminateEventDefinition do
      let(:xml) { fixture_source("terminate_event_definition_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("TerminateEventDefinitionTest") }
        let(:end_terminated_event) { process.element_by_id("EndTerminated") }

        it "should parse the terminate end event" do
          _(end_terminated_event.terminate_event_definition).wont_be_nil
        end
      end

      describe :execution do
      end
    end

    describe TimerEventDefinition do
      let(:xml) { fixture_source("timer_event_definition_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("TimerEventDefinitionTest") }
        let(:start_event) { process.element_by_id("Start") }
        let(:catch_event) { process.element_by_id("Catch") }
        let(:end_event) { process.element_by_id("End") }

        it "should parse the timers" do
          _(catch_event.timer_event_definition).wont_be_nil
          _(catch_event.timer_event_definition.time_duration).wont_be_nil
        end
      end

      describe :execution do
      end
    end
  end
end
