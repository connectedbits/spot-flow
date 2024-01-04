# frozen_string_literal: true

module SpotFlow
  module Bpmn
    class Element
      attr_accessor :type, :id, :name, :extension_elements

      def initialize(moddle)
        @type = moddle["$type"]
        @id = moddle["id"]
        @name = moddle["name"]
        @extension_elements = ExtensionElements.new(moddle["extensionElements"]) if moddle["extensionElements"].present?
      end

      def self.from_moddle(moddle)
        return nil if moddle["$type"].start_with?("bpmndi")
        begin
          if klass = "SpotFlow::Bpmn::#{moddle["$type"].split(':').last}".safe_constantize
            klass.new(moddle)
          else
            ap "Error creating instance of #{moddle["$type"]}"
            Element.new(moddle)
          end
        end
      end
    end

    class Message < Element
    end

    class Signal < Element
    end

    class Error < Element
    end

    class Collaboration < Element
    end

    class LaneSet < Element
    end

    class Participant < Element
      attr_accessor :process_ref, :process

      def initialize(moddle)
        super
        @process_ref = moddle["processRef"]
      end
    end
  end
end
