# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'frecli', 'version.rb'])

Gem::Specification.new do |s|
  s.name = 'frecli'
  s.version = Frecli::VERSION
  s.license = 'MIT'
  s.summary = 'Command line client for Freckle.'
  s.author = 'Jamie Schembri'
  s.email = 'jamie@schembri.me'
  s.homepage = 'http://github.com/shkm/frecli'
  s.platform = Gem::Platform::RUBY

  s.files = Dir['LICENSE', 'README.md', 'lib/**/*.rb']
  s.test_files = Dir['spec/**/*.rb']

  s.bindir = 'bin'
  s.executables << 'frecli'

  s.has_rdoc = true
  s.rdoc_options << '--title' << 'frecli'
  s.extra_rdoc_files = ['frecli.rdoc']

  s.add_development_dependency('rake', '~> 10.1')
  s.add_development_dependency('rdoc', '~> 4.2')
  s.add_development_dependency('aruba', '~> 0.11')
  s.add_development_dependency('webmock', '~> 1.22')
  s.add_development_dependency('rspec', '~> 3.4')
  s.add_development_dependency('pry-byebug', '~> 3.3')
  s.add_development_dependency('codeclimate-test-reporter', '>= 0.4')
  s.add_runtime_dependency('gli', '~> 2.13')
  s.add_runtime_dependency('terminal-table', '~> 1.5')
  s.add_runtime_dependency('freckle-api', '>= 0.1.4')
end
