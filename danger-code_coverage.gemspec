# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require('code_coverage/gem_version.rb')

Gem::Specification.new do |spec|
  spec.name = 'danger-code_coverage'
  spec.version = CodeCoverage::VERSION
  spec.authors = ['Kyaak']
  spec.email = ['kyaak.dev@gmail.com']
  spec.description = 'Danger plugin for Jenkins-Code-Coverage-Api plugin.'
  spec.summary = 'Read Jenkins code-coverage reports and comment pull request with coverage for changed files.'
  spec.homepage = 'https://github.com/Kyaak/danger-code_coverage'
  spec.license = 'MIT'

  spec.files = %x(git ls-files).split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>=2.3.0'

  spec.add_runtime_dependency('danger-plugin-api', '~> 1.0')

  # General ruby development
  spec.add_development_dependency('bundler', '~> 2.0')
  spec.add_development_dependency('rake', '~> 12.3')

  # Testing support
  spec.add_development_dependency('mocha', '~> 1.8')
  spec.add_development_dependency('rspec', '~> 3.8')
  spec.add_development_dependency('simplecov', '~> 0.16')
  spec.add_development_dependency('simplecov-console', '~> 0.4')

  # Linting code and docs
  spec.add_development_dependency('rubocop', '~> 0.68')
  spec.add_development_dependency('rubocop-performance', '~> 1.2')
  spec.add_development_dependency('rubocop-thread_safety', '~> 0.3')
  spec.add_development_dependency('yard', '~> 0.9')
end
