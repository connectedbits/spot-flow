# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :version do
    it "should have a version" do
      _(SpotFlow::VERSION).wont_be_nil
    end
  end

  describe :hello_world do
    before { @process = SpotFlow.new(source).start }

    let(:process) { @process }
    let(:source) { fixture_source("hello_world.bpmn") }
    let(:waiting_step) { process.waiting_tasks.first } # TODO: should this be called waiting_steps?

    it "the process should wait at the task" do
      _(process.completed?).must_equal false
      _(waiting_step).wont_be_nil
      _(waiting_step.waiting?).must_equal true
    end

    describe :serialization do
      before { @serialized_state = process.serialize }

      let(:serialized_state) { @serialized_state }

      it "serialize the process state" do
        _(serialized_state).wont_be_nil
      end

      describe :deserialization do
        before { @process = SpotFlow.new(fixture_source("hello_world.bpmn")).restore(serialized_state); }

        it "process should be restored to waiting state" do
          _(process.completed?).must_equal false
          _(waiting_step).wont_be_nil
          _(waiting_step.waiting?).must_equal true
        end 

        describe :signaling do
          before { waiting_step.signal({ message: "Hello World!" }) }

          it "should complete the process" do
            _(process.completed?).must_equal true
          end
        end
      end
    end
  end

  describe :kitchen_sink do

  end
end
