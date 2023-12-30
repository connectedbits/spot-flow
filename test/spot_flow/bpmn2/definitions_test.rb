# frozen_string_literal: true

require "test_helper"

module SpotFlow
  module Bpmn2
    describe Definitions do
      describe :simple do
        let(:xml) { fixture_source("hello_world.bpmn") }
        let(:definitions) { Definitions.from_xml(xml) }

        describe :definitions do
          it "should parse definitions" do
            _(definitions).wont_be_nil
            _(definitions.id).wont_be_nil
            _(definitions.execution_platform).must_equal("Camunda Cloud")
            _(definitions.execution_platform_version).wont_be_nil
            _(definitions.exporter).must_equal("Camunda Modeler")
            _(definitions.exporter_version).wont_be_nil
            _(definitions.target_namespace).must_equal("http://bpmn.io/schema/bpmn")
          end

          describe :process do
            let(:process) { definitions.processes.first }
            let(:start_event) { process.start_events.first }
            let(:task) { process.tasks.first }
            let(:end_event) { process.end_events.first }

            it "should parse the process" do
              _(process).wont_be_nil
              _(process.id).must_equal("HelloWorld")
              _(process.name).must_equal("Hello World")
              _(process.is_executable).must_equal(true)
            end

            describe :start_evewnt do
              it "should parse the start event" do
                _(start_event.id).must_equal("Start")
                _(start_event.name).must_equal("Start")
                _(start_event.incoming.empty?).must_equal(true)
                _(start_event.outgoing.first.target).must_equal(task)
                _(start_event.extension_elements).wont_be_nil
              end
            end

            describe :task do
              it "should parse the task" do
                _(task.id).must_equal("SayHello")
                _(task.name).must_equal("Say Hello")
                _(task.incoming.first.source).must_equal(start_event)
                _(task.outgoing.first.target).must_equal(end_event)
              end
            end

            describe :end_event do
              it "should parse the end event" do
                _(end_event.id).must_equal("End")
                _(end_event.name).must_equal("End")
                _(end_event.incoming.first.source).must_equal(task)
                _(end_event.outgoing.empty?).must_equal(true)
              end
            end
          end
        end
      end

      describe :complex do
        let(:xml) { fixture_source("kitchen_sink.bpmn") }
        let(:definitions) { Definitions.from_xml(xml) }

        describe :definitions do
          it "should parse definitions" do
            _(definitions).wont_be_nil
          end

          describe :process do
            let(:process) { definitions.processes.first }
            let(:start_event) { process.start_events.find { |e| e.id == "Start" } }
            let(:end_event) { process.end_events.find { |e| e.id == "End" } }

            it "should parse the process" do
              _(process.id).must_equal("KitchenSink")
              _(process.name).must_equal("Kitchen Sink")
              _(process.is_executable).must_equal(true)
              _(process.start_events.count).must_equal(2)
              _(process.end_events.count).must_equal(2)
              _(process.user_tasks.count).must_equal(1)
              _(process.business_rule_tasks.count).must_equal(1)
              _(process.script_tasks.count).must_equal(1)
              _(process.service_tasks.count).must_equal(2)
              _(process.sequence_flows.count).must_equal(14)
            end

            describe :start_events do
              it "should parse default start event" do
                _(start_event.id).must_equal("Start")
                _(start_event.name).must_equal("Start")
                _(start_event.incoming.empty?).must_equal(true)
                _(start_event.outgoing.first.target).must_equal(process.user_tasks.first)
              end
            end

            describe :activities do

            end

            describe :gateways do

            end

            describe :end_events do

            end
          end
        end
      end
    end
  end
end
