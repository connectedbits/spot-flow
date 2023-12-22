# frozen_string_literal: true

module SpotFlow
  module Services
    class ProcessWriter < ApplicationService
      PROCESS_WRITER_BIN = File.expand_path(File.dirname(__FILE__)) + "/process_writer.js"

      def initialize(moddle, env: nil)
        super()
        @moddle = moddle
        @env = env
      end

      def call
        execute_json_process(PROCESS_WRITER_BIN, @moddle, env: @env)
      end

      private

      def write_moddle(key, moddle)
        File.open("#{key}.json","w") do |f|
          f.write(moddle.to_json)
        end
      end
    end
  end
end
