# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'countdown/version'

Gem::Specification.new do |spec|
  spec.name          = 'countdown'
  spec.version       = Countdown::VERSION
  spec.authors       = ['Andreas Busold']
  spec.email         = ['an.bu@gmx.net']
  spec.description   = %q{Adds a visible countdown to your views, which counts down by supplied steps via JavaScript.}
  spec.summary       = %q{Adds a visible countdown to your views, which counts down by supplied steps via JavaScript.}
  spec.homepage      = 'https://github.com/neopoly/countdown'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest-spec-rails'
  spec.add_development_dependency 'railties'
end
