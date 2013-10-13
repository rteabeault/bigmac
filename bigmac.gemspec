# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bigmac/version'

Gem::Specification.new do |spec|
  spec.name          = "bigmac"
  spec.version       = BigMac::VERSION
  spec.authors       = ["Russell Teabeault"]
  spec.email         = ["rteabeault@gmail.com"]
  spec.description   = %q{Bootstrap your mac with bigmac}
  spec.summary       = %q{Bootstrap your mac with bigmac}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "webmock", "~> 1.11.0"


  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "mixlib-shellout", "~> 1.1.0"
  spec.add_dependency "rest-client", "~> 1.6.7"
  spec.add_dependency "json_pure", "~> 1.8.0"
end
