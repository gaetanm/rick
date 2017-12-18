module Rick
  class PullRequest
    MAX_OLD = 2

    attr_reader :data

    def initialize(gh)
      @gh = gh
      @data = []
    end

    def retrieve
      @data = []
      @gh.pull_requests.list("Keycoopt", "Keybab").each do |pr|
        @data << pr
      end
      self
    end

    def under_review
      cards = retrieve_cards_from_project
      prs_numbers = extract_prs_numbers(cards)
      @data.delete_if do |pr|
        true unless prs_numbers.include?(pr["number"].to_s)
      end
      self
    end

    def old(since = MAX_OLD)
      to = Date.today
      @data.delete_if do |pr|
        from = Date.parse(pr["updated_at"])
        true if ((to - from).to_i - total_off_days(from, to)) < since
      end
      self
    end

    def count
      @data.size
    end

    # Pas vraiment le rôle de cette classe...
    def total_off_days(from, to)
      total_off_days = 0
      (from..to).map(&:wday).each do |day|
        total_off_days += 1 if [0, 1].include?(day)
      end
      total_off_days
    end

    private

    def retrieve_cards_from_project
      project_id = (@gh.repos.projects.list owner: "Keycoopt", repo: "Keybab").first["id"]
      column_id = @gh.projects.columns.list(project_id)[1]["id"] # "En relecture"
      @gh.projects.cards.list(column_id)
    end

    def extract_prs_numbers(cards)
      prs_numbers = []
      cards.each do |card|
        prs_numbers << card["content_url"].split("/").last
      end
      prs_numbers
    end
  end
end
