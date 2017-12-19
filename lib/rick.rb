require "github_api"
require "slack-ruby-bot"
require "rick/version"
require "rick/pull_request"
require "rick/rick_brain"
require "rick/rick_bot"

module Rick
  @config = YAML::load_file ".rick.yml"

  class << self
    def config
      @config
    end
  end
end
