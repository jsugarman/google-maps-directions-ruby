# frozen_string_literal: true

require_relative 'lib/google_maps/directions/version'

Gem::Specification.new do |spec|
  spec.name          = 'google-maps-directions'
  spec.version       = GoogleMaps::Directions::VERSION
  spec.authors       = ['jsugarman']
  spec.email         = ['joel.sugarman@digital.justice.gov.uk']

  spec.summary       = 'Ruby client for Google Maps Directions API'
  spec.description   = <<~DESC
    The Ruby Client for Google Maps Directions is a Ruby Client library for the [Google Maps Direction API](https://developers.google.com/maps/documentation/directions/overview)
  DESC
  spec.homepage      = 'https://github.com/jsugarman/google-maps-directions-ruby'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jsugarman/google-maps-directions-ruby'
  spec.metadata['changelog_uri'] = 'https://github.com/jsugarman/google-maps-directions-ruby/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  # runtime dependencies
  spec.add_runtime_dependency 'addressable', '~> 2.3', '>= 2.3.7'
  spec.add_runtime_dependency 'faraday', '~> 1.0'

  # development dependencies
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 2.2.15'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.7'
  spec.add_development_dependency 'rubocop-performance', '~> 1.10'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.2'
end
