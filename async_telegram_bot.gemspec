# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'async_telegram/version'

Gem::Specification.new do |gem|
  gem.name        = 'async_telegram_bot'
  gem.version     = AsyncTelegram::VERSION
  gem.homepage    = 'https://github.com/Arugin/async_telegram_bot'

  gem.author      = 'Valery Mayatsky'
  gem.email       = 'valerymayatsky@gmail.com'
  gem.description = 'An async bot for telegram'
  gem.summary     = 'An async bot for telegram which works with webhook'

  gem.add_dependency 'eventmachine', '>= 1.2.0.1'
  gem.add_dependency 'virtus'
  gem.add_dependency 'oj'
  gem.add_dependency 'activesupport'
  gem.add_development_dependency 'bundler', '~> 1.0'

  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_paths = ['lib']
end
