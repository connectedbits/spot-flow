# frozen_string_literal: true

require "test_helper"

module SpotFlow
  describe :module do
    it "should have a version" do
      _(SpotFlow::VERSION).wont_be_nil
    end
  end

  describe :hello_world do
    let(:bpmn_xml) { fixture_source("hello_world.bpmn") }
    let(:dmn_xml) { fixture_source("choose_greeting.dmn") }
    let(:sources) { [bpmn_xml, dmn_xml] }

    describe :processes_from_xml do
      let(:processes) { SpotFlow.processes_from_xml(bpmn_xml) }
      let(:process) { processes.first }
      let(:start_event) { process.element_by_id("Start") }
      let(:user_task) { process.element_by_id("IntroduceYourself") }
      let(:boundary_event) { process.element_by_id("EggTimer") }
      let(:split_gateway) { process.element_by_id("Split") }
      let(:business_rule_task) { process.element_by_id("ChooseGreeting") }
      let(:service_task) { process.element_by_id("ChooseFortune") }
      let(:join_gateway) { process.element_by_id("Join") }
      let(:script_task) { process.element_by_id("GenerateMessage") }
      let(:end_event) { process.element_by_id("End") }

      it "should extract processes from XML" do
        _(process.id).must_equal "HelloWorld"
        _(process.name).must_equal "Hello World"
        _(start_event).wont_be_nil
        _(user_task).wont_be_nil
        _(boundary_event).wont_be_nil
        _(split_gateway).wont_be_nil
        _(business_rule_task).wont_be_nil
        _(service_task).wont_be_nil
        _(join_gateway).wont_be_nil
        _(script_task).wont_be_nil
        _(end_event.id).must_equal "End"
      end
    end

    describe :execution do
      before { @execution = SpotFlow.new(sources).start }

      let(:execution) { @execution }
      let(:start_event) { execution.child_by_step_id("Start") }
      let(:user_task) { execution.child_by_step_id("IntroduceYourself") }
      let(:boundary_event) { execution.child_by_step_id("EggTimer") }
      let(:split_gateway) { execution.child_by_step_id("Split") }
      let(:business_rule_task) { execution.child_by_step_id("ChooseGreeting") }
      let(:service_task) { execution.child_by_step_id("ChooseFortune") }
      let(:join_gateway) { execution.child_by_step_id("Join") }
      let(:script_task) { execution.child_by_step_id("GenerateMessage") }
      let(:end_event) { execution.child_by_step_id("End") }

      it "should initialize the context" do
        _(execution.started?).must_equal true
        _(user_task.waiting?).must_equal true
        _(boundary_event.waiting?).must_equal true
      end

      describe :serialization do
        let(:execution_state) { execution.serialize }

        it "should serialize the process state" do
          _(execution_state).wont_be_nil
        end

        describe :deserialization do
          before { @execution = SpotFlow.restore(sources, execution_state: execution_state) }

          it "process should be restored to waiting state" do
            _(execution.started?).must_equal true
            _(user_task.waiting?).must_equal true
            _(boundary_event.waiting?).must_equal true
          end

          # DEBUG: this should be waiting at the choose fortune step
          # describe :complete_user_task do
          #   before { user_task.signal(name: "Eric", language: "it", formal: false, cookie: true) }

          #   it "should signal the user task" do
          #     execution.print
          #     _(user_task.completed?).must_equal true
          #     _(choose_fortune.waiting?).must_equal true
          #   end
          # end
        end
      end
    end
  end
end
