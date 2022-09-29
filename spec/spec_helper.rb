# frozen_string_literal: true

require 'bundler/setup'

require 'simplecov'
SimpleCov.start do
  enable_coverage :branch

  add_group 'Data Sets', 'app/data_sets'
  add_group 'Jobs', 'app/jobs'
  add_group 'CRON', 'app/cron'
  add_group 'Kernel', 'lake_front_kernel'
  add_group 'API V1', 'app/grpc/v1'
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter '/app/config/'

  if ENV['CI']
    require 'simplecov-lcov'

    SimpleCov::Formatter::LcovFormatter.config do |c|
      c.report_with_single_file = true
      c.single_report_path = 'coverage/lcov.info'
    end

    formatter SimpleCov::Formatter::LcovFormatter
  end
end


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
