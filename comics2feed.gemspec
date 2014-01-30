# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'comics2feed/version'

Gem::Specification.new 'comics2feed', Comics2Feed::VERSION do |s|
  s.summary     = "Comic crawler and RSS generator"
  s.description = "Used to check configured comic sites and update RSS feed when new comics are found."
  s.authors     = ["Juhamatti Niemelä"]
  s.email       = 'iiska@iki.fi'
  s.homepage    = 'https://github.com/iiska/comics2feed'
  s.license     = 'MIT'

  s.files = Dir['bin/*'] + Dir['lib/**/*.rb'] + Dir['templates/*.erb'] +
    %w(README.md)
  s.bindir = 'bin'
  s.executables << 'comics2feed'

  s.test_files = Dir['test/**/*']

  s.required_ruby_version = ">= 1.9.3"
  s.add_runtime_dependency 'hpricot', '~> 0.8.6'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'simplecov'
end
