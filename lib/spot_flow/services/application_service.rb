# frozen_string_literal: true
require_relative "./process_executor"

module SpotFlow
  module Services
    class ApplicationService
      include ProcessExecutor

      def self.call(*args, **options, &block)
        new(*args, **options, &block).call
      end
    end
  end
end
