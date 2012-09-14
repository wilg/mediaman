require 'simplecov'
require 'coveralls'

SimpleCov.start 'rails'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end

require_relative "../lib/mediaman"