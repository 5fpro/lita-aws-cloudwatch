Gem::Specification.new do |spec|
  spec.name          = "lita-aws-cloudwatch"
  spec.version       = "0.1.0"
  spec.authors       = ["marsz"]
  spec.email         = ["marsz330@gmail.com"]
  spec.description   = "Receive AWS CloudWatch alarm from AWS SNS (Simple Notification Service), and messaging to room."
  spec.summary       = "AWS CloudWatch integration with AWS SNS"
  spec.homepage      = "https://github.com/5fpro/lita-aws-cloudwatch"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
