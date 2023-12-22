require_relative "lib/spot_flow/version"

Gem::Specification.new do |spec|
  spec.name        = "spot_flow"
  spec.version     = SpotFlow::VERSION
  spec.authors     = ["Connected Bits"]
  spec.email       = ["info@connectedbits.com"]
  spec.homepage    = "https://www.connectedbits.com"
  spec.summary     = "A BPMN workflow engine in Ruby"
  spec.description = "Spot Flow is a workflow gem for Rails applications based on the [bpmn](https://www.bpmn.org) standard. It executes business processes and rules defined in a modeler."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/connectedbits/process_pilot"

  spec.files = Dir["{lib,doc}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.required_ruby_version = ">= 3.1"

  spec.add_dependency "activesupport", ">= 7.0.2.3"
  spec.add_dependency "json_logic", "~> 0.4.7"
  spec.add_dependency "awesome_print", "~> 1.9"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "minitest-spec"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "minitest-focus"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "solargraph"
  spec.add_development_dependency "simplecov"
end
