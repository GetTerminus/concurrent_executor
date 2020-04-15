# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
end

require 'codecov'
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require 'concurrent_executor'

RSpec.configure do |config|
  Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].sort.each { |f| require f }
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
