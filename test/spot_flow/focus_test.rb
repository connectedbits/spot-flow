# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :focus_test do
    it "should execute the process" do
      processes = SpotFlow.processes_from_xml(fixture_source("hello_world.bpmn"))
      execution = SpotFlow.new(processes:).start
      _(execution).wont_be_nil
    end
  end
end
