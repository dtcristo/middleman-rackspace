# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-rackspace/pkg-info'

Gem::Specification.new do |s|
  s.name        = Middleman::Rackspace::PACKAGE
  s.version     = Middleman::Rackspace::VERSION
  s.authors     = ['David Cristofaro']
  s.homepage    = 'https://github.com/dtcristo/middleman-rackspace'
  s.summary     = Middleman::Rackspace::TAGLINE
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_runtime_dependency 'middleman-core', '>= 3.4.0'
  s.add_runtime_dependency 'fog', '~> 1.35.0'
  s.add_runtime_dependency 'typhoeus', '~> 0.8.0'
end
