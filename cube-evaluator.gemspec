# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cube-evaluator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matteo Depalo"]
  gem.email         = ["matteodepalo@gmail.com"]
  gem.description   = %q{Square Cube evaluator gem}
  gem.summary       = %q{Ruby gem to obtain data from a Cube evaluator}
  gem.homepage      = "https://github.com/matteodepalo/cube-evaluator"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "cube-evaluator"
  gem.require_paths = ["lib"]
  gem.version       = Cube::Evaluator::VERSION

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
