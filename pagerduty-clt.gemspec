# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagerduty/clt/version'

Gem::Specification.new do |spec|
  spec.name          = "pagerduty-clt"
  spec.version       = Pagerduty::CLT::VERSION
  spec.authors       = ["Ash McKenzie"]
  spec.email         = ["ash@the-rebellion.net"]

  spec.summary       = %q{Pagerduty CLT}
  spec.description   = %q{Pagerduty CLT - you know you want it!}
  spec.homepage      = "https://github.com/ashmckenzie/pagerduty-clt"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'clamp'
  spec.add_runtime_dependency 'dotenv'
  spec.add_runtime_dependency 'typhoeus'
  spec.add_runtime_dependency 'oj'
  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'dalli'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'faraday-http-cache'
  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'tzinfo'
  spec.add_runtime_dependency 'tzinfo-data'
  spec.add_runtime_dependency 'highline'
  spec.add_runtime_dependency 'naught'
  spec.add_runtime_dependency 'ruby-terminfo'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
