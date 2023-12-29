# frozen_string_literal: true

require "test_helper"

module SpotFlow
  module Bpmn2
    describe StartEvent do
      let(:xml) { fixture_source("start_event_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("StartEventTest") }
        let(:start_event) { process.element_by_id("Start") }

        it "should parse start events" do
          _(start_event).wont_be_nil
        end
      end

      describe :execution do
      end
    end

    describe IntermediateCatchEvent do
      let(:xml) { fixture_source("intermediate_catch_event_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("IntermediateCatchEventTest") }
        let(:catch_event) { process.element_by_id("Catch") }
      end

      describe :execution do
      end
    end

    describe IntermediateThrowEvent do
      let(:xml) { fixture_source("intermediate_throw_event_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("IntermediateThrowEventTest") }
        let(:throw_event) { process.element_by_id("Throw") }
      end

      describe :execution do
      end
    end

    describe BoundaryEvent do
      let(:xml) { fixture_source("boundary_event_test.bpmn") }

      describe :definition do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("BoundaryEventTest") }
        let(:start_event) { process.element_by_id("Start") }
        let(:host_task) { process.element_by_id("HostTask") }
        let(:non_interrupting_event) { process.element_by_id("NonInterrupting") }
        let(:interrupting_event) { process.element_by_id("Interrupting") }
        let(:end_event) { process.element_by_id("End") }
        let(:end_interrupted_event) { process.element_by_id("EndInterrupted") }

        it "should attach boundary to host" do
          skip "TODO: implement boundary event attachment"
          _(host_task.attachments.present?).must_equal true
          _(host_task.attachments).must_equal [non_interrupting_event, interrupting_event]
        end
      end

      describe :execution do
      end
    end

    describe EndEvent do
      let(:xml) { fixture_source("end_event_test.bpmn") }

      describe :definitions do
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.process_by_id("EndEventTest") }
        let(:end_event) { process.element_by_id("End") }

        it "should parse end events" do
          _(end_event).wont_be_nil
        end
      end

      describe :execution do
      end
    end
  end
end
