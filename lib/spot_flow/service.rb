# frozen_string_literal: true

module SpotFlow
  class Service
    def self.call(*args)
      new(*args).call
    end
  end
end
