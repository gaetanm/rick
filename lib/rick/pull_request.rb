module Rick
  class PullRequest
    MAX_OLD = 2

    attr_reader :data

    def initialize(gh, config)
      @gh = gh
      @data = []
      @config = config
    end

    def retrieve
      @data = []
      @gh.pull_requests.list(@config["repository"]["owner"], @config["repository"]["name"]).each do |pr|
        @data << pr
      end
      self
    end

    def under_review
      cards = retrieve_cards_from_project
      prs_numbers = extract_prs_numbers(cards)
      @data.delete_if {|pr| !prs_numbers.include?(pr["number"].to_s)}
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

    def without_changelog_update
      @data.delete_if { |pr| has_updated_changelog?(pr["body"]) }
      self
    end

    def count
      @data.size
    end

    # Not really the purpose of the class...
    def total_off_days(from, to)
      total_off_days = 0
      (from..to).map(&:wday).each do |day|
        total_off_days += 1 if [0, 1].include?(day)
      end
      total_off_days
    end

    private

    def has_updated_changelog?(body)
      body.include?("[x] Le CHANGELOG est à jour")
    end

    def retrieve_project
      projects = @gh.repos.projects.list owner: @config["repository"]["owner"], repo: @config["repository"]["name"]
      projects.detect { |p| p.name == @config["project"]["name"] }
    end

    def retrieve_column(project)
      columns = @gh.projects.columns.list(project["id"])
      columns.detect { |c| c.name == @config["project"]["column"]["name"] }
    end

    def retrieve_cards_from_project
      column = retrieve_column(retrieve_project)
      @gh.projects.cards.list(column["id"])
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
