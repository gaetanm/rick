module Rick
  class RickBrain
    include Singleton

    def initialize
      @config = Rick.config
      @gh = Github.new(basic_auth: "#{@config["github"]["username"]}:#{@config["github"]["token"]}")
      @pull_request = PullRequest.new(@gh, @config["github"])
    end

    def summarize
      prs = @pull_request.retrieve
      prs_under_review = prs.under_review.data.dup
      old_prs = prs.under_review.old.data
      msg = "Wubba Lubba dub-dub!\n"
      msg += "PRs en cours de relecture : #{prs_under_review.count}\n"
      msg += "PRs abandonnée(s) depuis au moins 2 jours : #{old_prs.count}\n"
      old_prs.each do |pr|
        msg += "\t"
        msg += "#{pr["title"]} -> #{pr["html_url"]}\n"
      end
      msg
    end
  end
end
