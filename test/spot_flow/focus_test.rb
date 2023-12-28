# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :focus_test do
    let(:source) { fixture_source("fine.dmn") }

    it "should work" do
      moddle = Services::DecisionReader.call(source)
      File.write("fine.dmn.json", JSON.pretty_generate(moddle))
    end
  end
end
