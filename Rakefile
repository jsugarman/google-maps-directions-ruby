# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = Dir['spec/**/*_spec.rb'].reject { |f| f['/integrations'] }
end

RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = Dir['spec/integrations/**/*_spec.rb']
end

task default: %i[rubocop unit integration]
