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
  config.allow_http_connections_when_no_cassette = true
  # Uncomment this line below just once when new cassette need to be generated.
  # config.filter_sensitive_data("<PIVOTAL_SECRET_TOKEN>") { ENV['PIVOTAL_SECRET_TOKEN'] }
end

# To allow tests to run without setting env data (where there are cassettes).
ENV["GITHUB_SECRET_TOKEN"] ||= "TEST"
ENV["PIVOTAL_SECRET_TOKEN"] ||= "TEST"
