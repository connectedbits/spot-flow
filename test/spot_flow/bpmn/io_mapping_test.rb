# # frozen_string_literal: true

# require "test_helper"

# module SpotFlow

#   describe "IO Mapping" do
#     let(:source) { fixture_source("io_mapping.bpmn") }
#     let(:context) { SpotFlow.new(source) }

#     describe :definition do
#       let(:process) { context.process_by_id("IOMapping") }
#       let(:start_event) { process.element_by_id("Start") }
#       let(:collect_money) { process.element_by_id("CollectMoney") }
#       let(:end_event) { process.element_by_id("End") }

#       it "should parse the task with io mappings" do
#         _(collect_money).wont_be_nil
#         _(collect_money.input_mappings.present?).must_equal true
#         _(collect_money.input_mappings.length).must_equal 4
#         _(collect_money.output_mappings.present?).must_equal true
#         _(collect_money.output_mappings.length).must_equal 1
#       end
#     end

#     describe :execution do
#       let(:process) { @process }
#       let(:start_event) { process.child_by_step_id("Start") }
#       let(:collect_money) { process.child_by_step_id("CollectMoney") }
#       let(:end_event) { process.child_by_step_id("End") }

#       before { @process = SpotFlow.new(source).start(variables: { order_id: "order-123", total_price: 25.0, customer: { name: "John", iban: "DE456" } }); }

#       describe :input_mapping do
#         it "should map input variables" do
#           _(collect_money.variables["sender"]).must_equal "John"
#           _(collect_money.variables["iban"]).must_equal "DE456"
#           _(collect_money.variables["price"]).must_equal 25
#           _(collect_money.variables["reference"]).must_equal "order-123"
#         end

#         describe :output_mapping do
#           before { collect_money.signal({ payment_status: "OK" }) }

#           it "should map output variables" do
#             _(process.variables["payment_status"]).must_equal "OK"
#           end
#         end
#       end
#     end
#   end
# end
