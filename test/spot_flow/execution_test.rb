# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe Execution do
    let(:source) { fixture_source("execution_test.bpmn") }
    let(:context) { Context.new(sources: source) }

    describe :definition do
      let(:process) { context.process_by_id("Process") }
      let(:start_event) { process.element_by_id("Start") }
      let(:task) { process.element_by_id("Task") }
      let(:catch_event) { process.element_by_id("Catch") }
      let(:end_event) { process.element_by_id("End") }
      let(:sub_process) { context.process_by_id("SubProcess") }
      let(:sub_start_event) { sub_process.element_by_id("SubStart") }
      let(:sub_task) { sub_process.element_by_id("SubTask") }
      let(:sub_end_event) { sub_process.element_by_id("SubEnd") }

      it "should parse the process" do
        _(process).wont_be_nil
        _(start_event).wont_be_nil
        _(task).wont_be_nil
        _(catch_event).wont_be_nil
        _(end_event).wont_be_nil
        _(sub_process).wont_be_nil
        _(sub_start_event).wont_be_nil
        _(sub_task).wont_be_nil
        _(sub_end_event).wont_be_nil
      end
    end

    describe :execution do
      let(:process) { @process }
      let(:start_event) { process.child_by_step_id("Start") }
      let(:task) { process.child_by_step_id("Task") }
      let(:catch_event) { process.child_by_step_id("Catch") }
      let(:end_event) { process.child_by_step_id("End") }
      let(:sub_process) { process.child_by_step_id("SubProcess") }
      let(:sub_start_event) { sub_process.child_by_step_id("SubStart") }
      let(:sub_task) { sub_process.child_by_step_id("SubTask") }
      let(:sub_end_event) { sub_process.child_by_step_id("SubEnd") }

      before { @process = SpotFlow.new(source).start }

      it "should start the process" do
        _(process.started?).must_equal true
        _(start_event.ended?).must_equal true
        _(task.waiting?).must_equal true
        _(catch_event.waiting?).must_equal true
      end

      describe :catch_and_bypass do
        before { catch_event.signal }

        it "should end the process" do
          _(process.completed?).must_equal true
          _(task.terminated?).must_equal true
          _(catch_event.ended?).must_equal true
          _(sub_process).must_be_nil
        end
      end

      describe :execute_sub_process do
        before { task.signal }

        it "should start the sub process" do
          _(sub_process.started?).must_equal true
          _(sub_task.waiting?).must_equal true
          _(catch_event.terminated?).must_equal true
        end

        describe :signal_sub do
          before { sub_task.signal }

          it "should end the process" do
            _(process.ended?).must_equal true
            _(sub_process.ended?).must_equal true
            _(end_event).wont_be_nil
          end
        end
      end
    end

    describe :serialization do
      let(:source) { fixture_source("execution_test.bpmn") }
      let(:context) { Context.new(sources: source) }
      let(:process) { @process }

      before { @process = SpotFlow.new(source).start }

      it "should start the process" do
        _(process.started?).must_equal true
      end

      describe :serialize do
        let(:json) { @json }

        before { @json = process.serialize }

        it "must serialize the execution tree" do
          _(json).wont_be_nil
        end

        describe :deserialize do
          let(:new_process) { @new_process }

          before { @new_process = SpotFlow.new(source).restore(json) }

          it "should deserialize the execution tree" do
            _(new_process.id).must_equal process.id
            _(new_process.status).must_equal process.status
            _(new_process.step.id).must_equal process.step.id
            _(new_process.children.length).must_equal process.children.length
          end

          it "should be lossless" do
            _(new_process.serialize).must_equal process.serialize
          end
        end
      end
    end
  end
end
