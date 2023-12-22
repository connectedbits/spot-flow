# frozen_string_literal: true
require "test_helper"

module SpotFlow
  module Services
    describe DecisionReader do
      let(:service) { DecisionReader }
      let(:source) { fixture_source("dish.dmn") }
      let(:moddle) { service.call(source) }

      it "should parse dmn moddle" do
        _(moddle).wont_be_nil
        _(moddle["drgElement"].first["id"]).must_equal("Dish")
      end
    end
  end
end
