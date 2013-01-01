# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'dm-session'
  s.version  = '0.0.0'

  s.authors  = ['Markus Schirp']
  s.email    = 'mbj@seonic.net'
  s.date     = '2012-02-14'
  s.summary  = 'State machine for object persistence'
  s.homepage = 'http://github.com/mbj/dm-session'

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.require_paths    = %w(lib)
  s.extra_rdoc_files = %w(README.md TODO LICENSE)

  s.rubygems_version = '1.8.10'
  s.add_dependency('backports',      '~> 2.6.4')
  s.add_dependency('adamantium',     '~> 0.0.3')
  s.add_dependency('equalizer',      '~> 0.0.1')
  s.add_dependency('abstract_type',  '~> 0.0.2')
end
