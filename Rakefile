require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

namespace :spec do
  desc "Run specs with RCov"
  RSpec::Core::RakeTask.new('rcov') do |t|
    t.rcov = true
  end
end
