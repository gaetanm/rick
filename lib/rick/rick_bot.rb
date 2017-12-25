module Rick
  class RickBot < SlackRubyBot::Bot
    command "hey" do |client, data, match|
      rick = RickBrain.instance
      client.say(text: rick.summarize, channel: data.channel)
    end

    # (https://github.com/slack-ruby/slack-ruby-bot#animated-gifs)
    command "roll" do |client, data, match|
      client.say(channel: data.channel, gif: "rickroll")
    end
  end
end
