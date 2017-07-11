# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gouncer/version"

Gem::Specification.new do |spec|
  spec.name           = "rack-gouncer"
  spec.version        = Gouncer::VERSION
  spec.authors        = ["RDux"]
  spec.email          = ["data@npolar.no"]
  spec.description    = "Midlware that allows authorization against the gouncer auth api"
  spec.summary        = "Uses the gouncer auth api to authorizer requests to the system"
  spec.homepage       = "https://github.com/npolar/rack-gouncer"
  spec.license        = "GPLv3"

  spec.files          = `git ls-files`.split($/)
  spec.executables    = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths  = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "simplecov"

  spec.add_dependency "rack",       "1.6.8"
  spec.add_dependency "yajl-ruby",  "1.3.0"
end
