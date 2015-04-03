# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-block/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['solarce']
  gem.email         = ['brandon@inatree.org']
  gem.description   = 'Create and manage knife.rb files for Chef'
  gem.summary       = gem.description
  gem.homepage      = 'https://github.com/knife-block/knife-block'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($ORS)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split($ORS)
  gem.executables   = `git ls-files -- bin/*`.split($ORS).map { |f| File.basename(f) }
  gem.name          = 'knife-block'
  gem.require_paths = ['lib']
  gem.version       = Knife::Block::VERSION

  gem.add_dependency('test-unit', '~> 2.5')
end
