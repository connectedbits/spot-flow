# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Element
      include ActiveModel::Model

      attr_accessor :id, :name, :extension_elements
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
    end
  end
end
