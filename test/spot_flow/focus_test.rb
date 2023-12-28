# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :focus_test do
    let(:sources) { fixture_source("kitchen_sink.bpmn") }

    it "should parse complicated diagrams" do
      #moddle = Services::ProcessReader.new(sources).call
      #File.open("tmp/kitchen_sink.json", "w") { |f| f.write(JSON.pretty_generate(moddle)) }
    end
  end
end
