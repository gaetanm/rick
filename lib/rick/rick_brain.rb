module Rick
  class RickBrain
    def initialize(login, password)
      @gh = Github.new basic_auth: "#{login}:#{password}"
    end

    def summarize
      pr = PullRequest.new(@gh)
      prs = pr.retrieve
      all_prs = prs.data.dup
      old_prs = prs.under_review.old.data
      msg = "Wubba Lubba dub-dub!\n"
      msg += "PRs en cours de relecture : #{all_prs.count}\n"
      msg += "PRs abandonnée(s) depuis au moins 2 jours : #{old_prs.count}\n"
      old_prs.each do |pr|
        msg += "\t"
        msg += "#{pr["title"]} -> #{pr["html_url"]}\n"
      end
      msg
    end
  end
end
