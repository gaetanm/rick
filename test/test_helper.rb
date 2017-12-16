$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rick"
require "minitest/reporters"
require "minitest/autorun"
require "vcr"
require "awesome_print"

Minitest::Reporters.use!

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end
