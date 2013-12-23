# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
puts $LOAD_PATH
require 'zvg_d3/version'

Gem::Specification.new do |spec|
  spec.name          = "zvg_d3"
  spec.version       = ZvgD3::Rails::VERSION
  spec.authors       = ["zvkemp"]
  spec.email         = ["zvkemp@gmail.com"]
  spec.description   = %q{Charts for D3}
  spec.summary       = %q{Work in progress}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["{lib,vendor}/**/*"] + ["README.md"] 
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "railties", "~> 3.1"
end
