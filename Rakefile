require 'bundler/setup'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a << '--color'
    a << '--format progress'
    a << '--require spec_helper'
  end.join(' ')
end

namespace :travis do
  desc 'Run tests on Travis'
  task ci: ['unit']
end

task :default => ['travis:ci']