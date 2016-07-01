# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-block/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["solarce"]
  gem.email         = ["brandon@inatree.org"]
  gem.description   = %q{Create and manage knife.rb files for Chef}
  gem.summary       = %q{Create and manage knife.rb files for Chef}
  gem.homepage      = "https://github.com/knife-block/knife-block"
  gem.license       = "MIT"
  gem.required_ruby_version = ">= 1.9.2"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "knife-block"
  gem.require_paths = ["lib"]
  gem.version       = Knife::Block::VERSION

  gem.add_dependency('test-unit', '~> 2.5')
end
