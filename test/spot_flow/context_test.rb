# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe Context do
    describe :listeners do
      let(:source) { fixture_source("execution_test.bpmn") }
      let(:listeners) {
        {
          execution_started:    proc { |_args| log.push "execution started" },
          execution_waited:     proc { |_args| log.push "execution waited" },
          execution_ended:      proc { |_args| log.push "execution ended" },
          flow_taken:           proc { |_args, _sequence_flow| log.push "flow taken" },
          message_thrown:       proc { |_args, message_name| log.push "message #{message_name} thrown" },
          error_thrown:         proc { |_args, error_name| log.push "error #{error_name} thrown" },
        }
      }
      let(:context) { Context.new(sources: source, listeners: listeners) }
      let(:log) { @log }
      let(:last)

      before do
        @log = []
        processes = SpotFlow.processes_from_xml(fixture_source("execution_test.bpmn"))
        @process = SpotFlow.new(processes:, listeners:).start
      end

      it "should call the listener" do
        _(log.last).must_equal "execution waited"
      end
    end
  end
end
