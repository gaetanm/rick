require "github_api"
require "slack-ruby-bot"
require "tracker_api"
require "rick/version"
require "rick/pull_request"
require "rick/rick_brain"
require "rick/rick_bot"
require "singleton"

module Rick
  @config = YAML::load_file(".rick.yml")

  class << self
    def config
      @config["github"]["token"]  = ENV["GITHUB_SECRET_TOKEN"]
      @config["pivotal"]["token"] = ENV["PIVOTAL_SECRET_TOKEN"]
      @config
    end
  end
end
