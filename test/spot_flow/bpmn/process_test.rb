# frozen_string_literal: true

require "test_helper"

module SpotFlow
  module Bpmn
    describe Process do
      describe :from_xml do
        describe :hello_world do
          let(:xml) { fixture_source("hello_world.bpmn") }
          let(:definitions) { Definitions.from_xml(xml) }
          let(:process) { definitions.processes.first }

          it "should initialize the process" do
            _(process.id).must_equal("HelloWorld")
            _(process.name).must_equal("Hello World")
            _(process.start_events.count).must_equal(1)
            _(process.tasks.count).must_equal(1)
            _(process.end_events.count).must_equal(1)
          end
        end

        describe :kitchen_sink do
          let(:xml) { fixture_source("kitchen_sink.bpmn") }
          let(:definitions) { Definitions.from_xml(xml) }
          let(:process) { definitions.processes.first }
          let(:default_start_event) { process.default_start_event }
          let(:message_start_event) { process.start_events.find { |event| event.id == "IntroReceived" } }

          it "should initialize the process" do
            _(process.id).must_equal("KitchenSink")
            _(process.name).must_equal("Kitchen Sink")
            _(process.start_events.count).must_equal(2)
            _(process.user_tasks.count).must_equal(1)
            _(process.script_tasks.count).must_equal(1)
            _(process.business_rule_tasks.count).must_equal(1)
            _(process.service_tasks.count).must_equal(2)
            _(process.exclusive_gateways.count).must_equal(1)
            _(process.parallel_gateways.count).must_equal(2)
            _(process.end_events.count).must_equal(2)
          end

          describe :start_events do
            it "should initialize the default start event" do
              _(default_start_event.name).must_equal("Start")
            end

            it "should initialize the message start event" do
              _(message_start_event.name).must_equal("Intro Received")
              _(message_start_event.event_definitions.count).must_equal(1)
            end
          end
        end
      end
    end
  end
end
