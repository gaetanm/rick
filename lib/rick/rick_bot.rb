require "awesome_print"
require "slack-ruby-bot"

module Rick
  class RickBot < SlackRubyBot::Bot
    command "hey" do |client, data, match|
      rick = RickBrain.new("gaetanm", ENV["GITHUB_SECRET_TOKEN"])
      client.say(text: rick.summarize, channel: data.channel)
    end

    # Décommenter la gem giphy pour rendre la méthode fonctionnelle.
    # Dans le cas échéant, chaque fonction renvoie un gif et c'est vite relou...
    # (https://github.com/slack-ruby/slack-ruby-bot#animated-gifs)
    command "roll" do |client, data, match|
      client.say(channel: data.channel, gif: "rickroll")
    end
  end
end
