# frozen_string_literal: true
require "test_helper"

module SpotFlow
  module Services
    describe DecisionEvaluator do
      describe(:example_one) do
        let(:source) { fixture_source("dish.dmn") }
        let(:decision_name) { "Dish" }

        describe :evaluate do
          let(:context) {
            {
              season: "Spring",
              guests: 7,
            }
          }
          let(:result) { DecisionEvaluator.call(decision_name, source, context) }

          it "should correctly parse and eval a dmn rule" do
            _(result["dish"]).must_equal "Steak"
          end
        end
      end

      describe(:example_two) do
        let(:source) { fixture_source("choose_greeting.dmn") }
        let(:decision_name) { "ChooseGreeting" }

        describe :evaluate do
          let(:context) {
            {
              language: "fr",
              formal:   true,
            }
          }
          let(:result) { DecisionEvaluator.call(decision_name, source, context) }

          it "should correctly parse and eval a dmn rule" do
            _(result["greeting"]).must_equal "Bonjour"
          end
        end
      end

      describe(:builtin_functions) do
        let(:source) { fixture_source("builtin_functions.dmn") }
        let(:decision_name) { "output" }

        describe :evaluate do
          let(:context) {
            {
              name: "Elijah",
            }
          }
          let(:result) { DecisionEvaluator.call(decision_name, source, context) }

          it "should correctly parse and eval a dmn rule" do
            _(result).must_equal("upper case" => "ELIJAH")
          end
        end
      end

      describe(:custom_functions_as_file) do
        let(:source) { fixture_source("custom_functions.dmn") }
        let(:decision_name) { "output" }

        describe :evaluate do
          let(:context) {
            {
              point: Time.new(2001, 2, 3, 4, 5, 11, "+00:00"),
            }
          }
          let(:result) { DecisionEvaluator.call(decision_name, source, context, functions: file_fixture("custom_functions.js")) }

          it "should correctly parse and eval a dmn rule" do
            _(result).must_equal("format datetime" => "2001-02-03 04:05:11 am")
          end
        end
      end

      describe(:custom_functions_as_string) do
        let(:source) { fixture_source("custom_functions.dmn") }
        let(:decision_name) { "output" }

        describe :evaluate do
          let(:context) {
            {
              point: Time.new(2001, 2, 3, 4, 5, 11, "+00:00"),
            }
          }
          let(:result) { DecisionEvaluator.call(decision_name, source, context, functions: file_fixture("custom_functions.js").read) }

          it "should correctly parse and eval a dmn rule" do
            _(result).must_equal("format datetime" => "2001-02-03 04:05:11 am")
          end
        end
      end
    end
  end
end
