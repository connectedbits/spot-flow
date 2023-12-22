# frozen_string_literal: true
require "test_helper"

module SpotFlow
  module Services
    describe FeelEvaluator do
      let(:service) { FeelEvaluator }

      describe :literal do
        let(:expression) { "'myName'" }
        let(:variables) { {} }
        let(:result) { service.call(expression: expression, variables: variables) }

        it "should return string" do
          _(result).must_equal("myName")
        end
      end

      describe :variable do
        let(:expression) { "name" }
        let(:variables) { { name: "Eric" } }
        let(:result) { service.call(expression: expression, variables: variables) }

        it "should return variable" do
          _(result).must_equal("Eric")
        end
      end

      describe :arithmetic do
        let(:expression) { "a + b + c" }
        let(:variables) { { a: 3, b: -1, c: 10 } }
        let(:result) { service.call(expression: expression, variables: variables) }

        it "should do math" do
          _(result).must_equal(12)
        end
      end

      describe :string_joining do
        let(:expression) { '"a" + "b" + var' }
        let(:variables) { { var: "c" } }
        let(:result) { service.call(expression: expression, variables: variables) }

        it "should join" do
          _(result).must_equal("abc")
        end
      end

      describe :builtin_functions do
        let(:expression) { "upper case(name)" }
        let(:variables) { { name: "aBc123" } }
        let(:result) { service.call(expression: expression, variables: variables) }

        it "should upper case" do
          _(result).must_equal("ABC123")
        end
      end

      describe :custom_functions_as_file do
        let(:expression) { "format datetime(date and time(point), 'YYYY-MM-DD hh:mm:ss a')" }
        let(:variables) { { point: Time.new(2001, 2, 3, 4, 5, 11, "+00:00") } }
        let(:result) { service.call(expression: expression, variables: variables, functions: file_fixture("custom_functions.js")) }

        it "should format time" do
          _(result).must_equal("2001-02-03 04:05:11 am")
        end
      end

      describe :custom_functions_as_string do
        let(:expression) { "format datetime(date and time(point), 'YYYY-MM-DD hh:mm:ss a')" }
        let(:variables) { { point: Time.new(2001, 2, 3, 4, 5, 11, "+00:00") } }
        let(:result) { service.call(expression: expression, variables: variables, functions: fixture_source("custom_functions.js")) }

        it "should format time" do
          _(result).must_equal("2001-02-03 04:05:11 am")
        end
      end
    end
  end
end