# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :focus_test do
    let(:xml) { fixture_source("hello_world.bpmn") }

    describe :processes_from_xml do
      let(:processes) { SpotFlow.processes_from_xml(xml) }
      let(:process) { processes.first }
      let(:start_event) { process.start_events.first }
      let(:task) { process.tasks.first }
      let(:end_event) { process.end_events.first }

      it "should extract processes from XML" do
        _(process.id).must_equal "HelloWorld"
        _(process.name).must_equal "Hello World"
        _(start_event.id).must_equal "Start"
        _(start_event.outgoing.first.target).must_equal task
        _(task.id).must_equal "SayHello"
        _(task.outgoing.first.target).must_equal end_event
        _(end_event.id).must_equal "End"
      end
    end

    describe :execution do
      let(:execution) { SpotFlow.new(xml).start }
      let(:waiting_step) { execution.child_by_step_id("SayHello") }

      it "should initialize the context" do
        _(execution.started?).must_equal true
        _(waiting_step.waiting?).must_equal true
      end

      describe :serialization do
        let(:execution_state) { execution.serialize }

        it "should serialize the process state" do
          _(execution_state).wont_be_nil
        end

        describe :deserialization do
          let(:restored_execution) { SpotFlow.restore(xml, execution_state: execution_state) }

          it "process should be restored to waiting state" do
            _(restored_execution.completed?).must_equal false
            _(waiting_step).wont_be_nil
            _(waiting_step.waiting?).must_equal true
          end

          describe :complete_execution do
            it "should signal the task" do
              waiting_step.signal
              _(waiting_step.completed?).must_equal true
              _(restored_execution.completed?).must_equal true
            end
          end
        end
      end
    end
  end
end
