module Rick
  class RickBrain
    include Singleton

    def initialize
      @config = Rick.config
      @gh = Github.new(basic_auth: "#{@config["github"]["username"]}:#{@config["github"]["token"]}")
      @pivotal = TrackerApi::Client.new(token: @config["pivotal"]["token"])
      @story = Story.new(@pivotal, @config["pivotal"])
      @pull_request = PullRequest.new(@gh, @config["github"])
    end

    def summarize
      summarize_github + summarize_pivotal
    end

    private

    def summarize_github
      prs = @pull_request.retrieve
      prs_under_review = prs.under_review.data.dup
      prs_without_changelog_update_under_review = prs.under_review.without_changelog_update.data.dup
      old_prs = prs.under_review.old.data
      msg = "Wubba Lubba dub-dub!\n"
      msg += "PR(s) en cours de relecture : #{prs_under_review.count}\n"
      msg += "PR(s) abandonnée(s) depuis au moins 2 jours : #{old_prs.count}\n"
      old_prs.each do |pr|
        msg += "\t"
        msg += "#{pr["title"]} -> #{pr["html_url"]}\n"
      end
      msg += "PR(s) avec oubli de màj du CHANGELOG : #{prs_without_changelog_update_under_review.count}\n"
      prs_without_changelog_update_under_review.each do |pr|
        msg += "\t"
        msg += "#{pr["title"]} -> #{pr["html_url"]}\n"
      end
      msg
    end

    def summarize_pivotal
      stories = @story.retrieve.with_state("delivered").data
      msg = "Histoire(s) en attente de recette: #{stories.count}\n"
      stories.each do |s|
        msg += "\t"
        msg += "#{s.name} -> #{s.url}\n"
      end
      msg
    end
  end
end
