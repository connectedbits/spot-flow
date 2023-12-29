# frozen_string_literal: true

module SpotFlow
  module Bpmn2
    class Gateway < Step
    end

    class ExclusiveGateway < Gateway
    end

    class ParallelGateway < Gateway
    end

    class InclusiveGateway < Gateway
    end

    class EventBasedGateway < Gateway
    end
  end
end
