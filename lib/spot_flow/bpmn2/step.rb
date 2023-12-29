# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Step
      include ActiveModel::Model
      include ActiveModel::Serialization

      attr_accessor :id, :name, :extension_elements, :incoming, :outgoing

      def attributes
        {
          "id": nil,
          "name": nil,
          "extension_elements": {},
          "incomming": [],
          "outgoing": [],
        }
      end
    end
  end
end
