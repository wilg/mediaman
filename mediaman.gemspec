# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mediaman/version'

Gem::Specification.new do |gem|
  gem.name          = "mediaman"
  gem.version       = Mediaman::VERSION
  gem.authors       = ["Wil Gieseler"]
  gem.email         = ["supapuerco@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'activesupport', '>=3.0.0'
  gem.add_dependency 'thor'
  gem.add_dependency 'mini_subler'
  gem.add_dependency 'httparty'
  gem.add_dependency 'hashie'
  
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  
end
