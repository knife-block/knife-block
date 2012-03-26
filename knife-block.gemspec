# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-block/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["proffalken"]
  gem.email         = ["theprofessor@threedrunkensysadsonthe.net"]
  gem.description   = %q{Create and manage knife.rb files for OpsCodes' Chef}
  gem.summary       = %q{Create and manage knife.rb files for OpsCodes' Chef}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "knife-block"
  gem.require_paths = ["lib"]
  gem.version       = Knife::Block::VERSION
end
