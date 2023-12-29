# frozen_string_literal: true

require "test_helper"

module SpotFlow
  module Bpmn2
    describe Definitions do
      describe :simple do
        let(:xml) { fixture_source("hello_world.bpmn") }
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.processes.first }
        let(:start_event) { process.start_events.first }
        let(:end_event) { process.end_events.first }
        let(:task) { process.tasks.first }
        let(:sequence_flows) { process.sequence_flows }

        describe :definitions do
          it "should parse definitions" do
            _(definitions).wont_be_nil
            _(definitions.id).wont_be_nil
            _(definitions.execution_platform).must_equal("Camunda Cloud")
            _(definitions.execution_platform_version).wont_be_nil
            _(definitions.exporter).must_equal("Camunda Modeler")
            _(definitions.exporter_version).wont_be_nil
            _(definitions.target_namespace).must_equal("http://bpmn.io/schema/bpmn")
            _(definitions.processes.empty?).must_equal(false)
          end

          describe :process do
            it "should parse the process" do
              _(process).wont_be_nil
              _(process.id).must_equal("HelloWorld")
              _(process.name).must_equal("Hello World")
              _(process.is_executable).must_equal(true)
            end

            describe :events do
              it "should parse the start event" do
                _(start_event).wont_be_nil
                _(start_event.class).must_equal(Bpmn2::StartEvent)
                _(start_event.id).must_equal("Start")
                _(start_event.name).must_equal("Start")
                _(start_event.incoming).must_be_nil
                _(start_event.outgoing).must_equal(["Flow_0zlro9p"])
                _(start_event.extension_elements).wont_be_nil
              end

              it "should parse the end event" do
                _(end_event).wont_be_nil
                _(end_event.class).must_equal(Bpmn2::EndEvent)
                _(end_event.id).must_equal("End")
                _(end_event.name).must_equal("End")
                _(end_event.incoming).must_equal(["Flow_1doumjv"])
                _(end_event.outgoing).must_be_nil
              end
            end

            describe :tasks do
              it "should parse the task" do
                _(task).wont_be_nil
                _(task.class).must_equal(Bpmn2::Task)
                _(task.id).must_equal("SayHello")
                _(task.name).must_equal("Say Hello")
                _(task.incoming).must_equal(["Flow_0zlro9p"])
                _(task.outgoing).must_equal(["Flow_1doumjv"])
              end
            end

            describe :sequence_flows do
              it "should parse the first sequence flow" do
                sequence_flow = sequence_flows.first
                _(sequence_flow).wont_be_nil
                _(sequence_flow.class).must_equal(Bpmn2::SequenceFlow)
                _(sequence_flow.id).must_equal("Flow_0zlro9p")
                _(sequence_flow.source_ref).must_equal("Start")
                _(sequence_flow.target_ref).must_equal("SayHello")
              end

              it "should parse the last sequence flow" do
                sequence_flow = sequence_flows.last
                _(sequence_flow).wont_be_nil
                _(sequence_flow.class).must_equal(Bpmn2::SequenceFlow)
                _(sequence_flow.id).must_equal("Flow_1doumjv")
                _(sequence_flow.source_ref).must_equal("SayHello")
                _(sequence_flow.target_ref).must_equal("End")
              end
            end
          end
        end
      end

      # '{:id=>"KitchenSink",
      # :name=>"Kitchen Sink",
      # :is_executable=>"true",
      # :start_event=>
      #  [{:id=>"Start", :name=>"Start", :outgoing=>"Flow_0nnf51e"},
      #   {:id=>"IntroReceived",
      #    :name=>"Intro Received",
      #    :extension_elements=>{:properties=>{:property=>{:name=>"camundaModeler:exampleOutputJson", :value=>"{ \"name\": \"Joe\", language: \"es\", \"formal\": false, cookie: false, error: true }"}}},
      #    :outgoing=>"Flow_053ahjv",
      #    :message_event_definition=>{:id=>"MessageEventDefinition_01cbipb", :message_ref=>"Message_23d9h1o"}}],
      # :sequence_flow=>
      #  [{:id=>"Flow_0nnf51e", :source_ref=>"Start", :target_ref=>"IntroduceYourself"},
      #   {:id=>"Flow_1umbmo5", :source_ref=>"IntroduceYourself", :target_ref=>"Split"},
      #   {:id=>"Flow_0npb0rm", :source_ref=>"Split", :target_ref=>"ChooseGreeting"},
      #   {:id=>"Flow_0r55ikx", :source_ref=>"ChooseGreeting", :target_ref=>"Join"},
      #   {:id=>"Flow_1485rqk", :source_ref=>"Join", :target_ref=>"AuthorMessage"},
      #   {:id=>"Flow_0olay0o", :source_ref=>"AuthorMessage", :target_ref=>"SendMessage"},
      #   {:id=>"Flow_0i87dy3", :source_ref=>"SendMessage", :target_ref=>"End"},
      #   {:id=>"Flow_0fm9oq9", :source_ref=>"Split", :target_ref=>"WantsCookie"},
      #   {:id=>"Flow_1d1hs5n", :name=>"yes", :source_ref=>"WantsCookie", :target_ref=>"GenerateFortune", :condition_expression=>"=cookie = true"},
      #   {:id=>"Flow_0ixux5h", :source_ref=>"GenerateFortune", :target_ref=>"Join"},
      #   {:id=>"Flow_053ahjv", :source_ref=>"IntroReceived", :target_ref=>"Split"},
      #   {:id=>"Flow_1dteozl", :source_ref=>"SendError", :target_ref=>"EndError"},
      #   {:id=>"Flow_0ehgwup", :name=>"no", :source_ref=>"WantsCookie", :target_ref=>"Join", :condition_expression=>"=cookie = false"},
      #   {:id=>"Flow_1rcca7d", :source_ref=>"TimesUp", :target_ref=>"End"}],
      # :user_task=>
      #  {:id=>"IntroduceYourself",
      #   :name=>"Introduce Yourself",
      #   :extension_elements=>{:properties=>{:property=>{:name=>"camundaModeler:exampleOutputJson", :value=>"{ \"name\": \"Eric\", \"language\": \"it\", \"formal\": false, \"cookie\": true }"}}, :form_definition=>{:form_key=>"introduce_yourself"}},
      #   :incoming=>"Flow_0nnf51e",
      #   :outgoing=>"Flow_1umbmo5"},
      # :parallel_gateway=>[{:id=>"Split", :name=>"Split", :incoming=>["Flow_1umbmo5", "Flow_053ahjv"], :outgoing=>["Flow_0npb0rm", "Flow_0fm9oq9"]}, {:id=>"Join", :name=>"Join", :incoming=>["Flow_0r55ikx", "Flow_0ixux5h", "Flow_0ehgwup"], :outgoing=>"Flow_1485rqk"}],
      # :end_event=>[{:id=>"End", :name=>"End", :incoming=>["Flow_0i87dy3", "Flow_1rcca7d"]}, {:id=>"EndError", :name=>"End Error", :incoming=>"Flow_1dteozl", :message_event_definition=>{:id=>"MessageEventDefinition_11v1crx"}}],
      # :exclusive_gateway=>{:id=>"WantsCookie", :name=>"Tell Fortune?", :incoming=>"Flow_0fm9oq9", :outgoing=>["Flow_1d1hs5n", "Flow_0ehgwup"]},
      # :boundary_event=>
      #  [{:id=>"SendError", :name=>"Error Sending Message", :attached_to_ref=>"SendMessage", :outgoing=>"Flow_1dteozl", :error_event_definition=>{:id=>"ErrorEventDefinition_1vvcknp"}},
      #   {:id=>"TimesUp", :name=>"Time's Up", :cancel_activity=>"false", :attached_to_ref=>"IntroduceYourself", :outgoing=>"Flow_1rcca7d", :timer_event_definition=>{:id=>"TimerEventDefinition_1udsx5l", :time_duration=>"PT2H"}}],
      # :service_task=>
      #  [{:id=>"GenerateFortune", :name=>"Generate Fortune", :extension_elements=>{:task_definition=>{:type=>"generate_fortune"}}, :incoming=>"Flow_1d1hs5n", :outgoing=>"Flow_0ixux5h"},
      #   {:id=>"SendMessage", :name=>"Send Message", :extension_elements=>{:task_definition=>{:type=>"SendMessageJob"}}, :incoming=>"Flow_0olay0o", :outgoing=>"Flow_0i87dy3"}],
      # :business_rule_task=>{:id=>"ChooseGreeting", :name=>"Choose Greeting", :extension_elements=>{:called_decision=>{:decision_id=>"ChooseGreeting", :result_variable=>"greeting"}}, :incoming=>"Flow_0npb0rm", :outgoing=>"Flow_0r55ikx"},
      # :script_task=>
      #  {:id=>"AuthorMessage",
      #   :name=>"Author Message",
      #   :extension_elements=>{:script=>{:expression=>"=if cookie then\n" + "  \"👋 \" + greeting + \" \" + name + \" 🥠\" + fortune\n" + "else\n" + "  \"👋 \" + greeting + \" \" + name\n", :result_variable=>"message"}},
      #   :incoming=>"Flow_1485rqk",
      #   :outgoing=>"Flow_0olay0o"}}'
      describe :complex do
        let(:xml) { fixture_source("kitchen_sink.bpmn") }
        let(:definitions) { Definitions.from_xml(xml) }
        let(:process) { definitions.processes.first }
        let(:start_events) { process.start_events }
        let(:start_event) { process.start_events.find { |se| se.id == "Start" } }
        let(:message_start_event) { process.start_events.find { |se| se.id == "IntroReceived" } }
        let(:end_events) { process.end_events }
        let(:end_event) { process.start_events.find { |ee| ee.id == "End" } }
        let(:error_end_event) { process.start_events.find { |ee| ee.id == "EndError" } }
        let(:user_task) { process.user_tasks.first }
        let(:business_rule_task) { process.business_rule_tasks.first }
        let(:script_task) { process.script_tasks.first }
        let(:service_tasks) { process.service_tasks }
        let(:auto_service_task) { process.service_tasks.find { |st| st.id == "GenerateFortune" } }
        let(:manual_service_task) { process.service_tasks.find { |st| st.id == "SendMessage" } }
        let(:sequence_flows) { process.sequence_flows }

        describe :definitions do
          it "should parse definitions" do
            _(definitions).wont_be_nil
            _(process).wont_be_nil
          end

          describe :process do
            it "should parse the process" do
              _(process).wont_be_nil
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

            describe :events do
              it "should parse the start events" do
                _(start_event.class).must_equal(Bpmn2::StartEvent)
                _(start_event.id).must_equal("Start")
                _(start_event.name).must_equal("Start")
                _(start_event.incoming).must_be_nil
                _(start_event.outgoing).must_equal(["Flow_0nnf51e"])

                _(message_start_event.class).must_equal(Bpmn2::StartEvent)
                _(message_start_event.id).must_equal("IntroReceived")
                _(message_start_event.name).must_equal("Intro Received")
                _(message_start_event.incoming).must_be_nil
                _(message_start_event.outgoing).must_equal(["Flow_053ahjv"])
                _(message_start_event.message_event_definition.message_ref).must_equal("Message_23d9h1o")
              end
            end

            describe :gateways do
            end

            describe :tasks do
            end

            describe :sequence_flows do
            end
          end
        end
      end
    end
  end
end
