# frozen_string_literal: true

require_relative 'lib/concurrent_executor/version'

Gem::Specification.new do |spec|
  spec.name          = 'concurrent_executor'
  spec.version       = ConcurrentExecutorVersion::VERSION
  spec.authors       = ['Brian Malinconico']
  spec.email         = ['bmalinconico@terminus.com']

  spec.summary       = 'Execute things concurrently'
  spec.description   = 'Executes things concurrently'
  spec.homepage      = 'https://github.com/GetTerminus/concurrent_executor'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = 'https://www.rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/GetTerminus/concurrent_executor'
  spec.metadata['changelog_uri'] = 'https://github.com/GetTerminus/concurrent_executor/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rubocop'
end
