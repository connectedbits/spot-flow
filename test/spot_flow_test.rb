# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :module do
    it "should have a version" do
      _(SpotFlow::VERSION).wont_be_nil
    end
  end

  describe :hello_world do
    before { @execution = SpotFlow.new(sources).start }

    let(:sources) { fixture_source("hello_world.bpmn") }
    let(:execution) { @execution }
    let(:waiting_step) { execution.waiting_tasks.first }  # TODO: should this be called waiting_steps?

    it "the process should wait at the task" do
      _(execution.completed?).must_equal false
      _(waiting_step).wont_be_nil
      _(waiting_step.waiting?).must_equal true
    end

    describe :serialization do
      let(:execution_state) { @execution_state }

      before { @execution_state = execution.serialize }

      it "serialize the process state" do
        _(execution_state).wont_be_nil
      end

      describe :deserialization do
        before { @execution = SpotFlow.restore(sources, execution_state:) }

        it "process should be restored to waiting state" do
          _(execution.completed?).must_equal false
          _(waiting_step).wont_be_nil
          _(waiting_step.waiting?).must_equal true
        end

        describe :signaling do
          before { waiting_step.signal({ message: "Hello World!" }) }

          it "should complete the process" do
            _(execution.completed?).must_equal true
          end
        end
      end
    end
  end

  describe :kitchen_sink do

  end
end
