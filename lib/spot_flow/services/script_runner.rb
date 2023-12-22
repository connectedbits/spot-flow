# frozen_string_literal: true

module SpotFlow
  module Services
    class ScriptRunner
      attr_reader :script, :variables, :procs

      def self.call(script:, variables: {}, procs: {})
        new(script: script, variables: variables, procs: procs).call
      end

      def initialize(script:, variables: {}, procs: {})
        super()
        @script = script
        @variables = variables
        @procs = procs || {}
      end

      def call
        raise "Script tasks disabled until mini racer deployment is fixed."
        # ctx = MiniRacer::Context.new
        # procs.each do |key, value|
        #   ctx.attach(key.to_s, value)
        # end
        # ctx.eval "variables = #{variables.to_json}; #{script}"
      end
    end
  end
end
