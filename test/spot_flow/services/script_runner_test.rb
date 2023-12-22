# frozen_string_literal: true
require "test_helper"

module SpotFlow
  module Services
    describe ScriptRunner do
      let(:service) { ScriptRunner }

      # describe :simple do
      #   let(:script) { "2 + 2" }
      #   let(:result) { service.call(script: script) }

      #   it "should eval the script correctly" do
      #     _(result).must_equal 4
      #   end
      # end

      # describe :complex do
      #   let(:script) { "`Hello ${reverse(variables.name)}`" }
      #   let(:procs) {
      #     {
      #       'reverse': proc { |input| input.reverse },
      #     }
      #   }
      #   let(:result) { service.call(script: script, variables: { name: "Eric" }, procs: procs) }

      #   it "should eval the script correctly" do
      #     _(result).must_equal "Hello cirE"
      #   end
      # end
    end
  end
end