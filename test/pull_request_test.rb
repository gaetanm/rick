require "test_helper"

class PullRequestTest < ActiveSupport::TestCase

  def setup
    config = Rick.config
    gh = Github.new(basic_auth: "#{config["github"]["username"]}:#{config["github"]["token"]}")
    @pr = Rick::PullRequest.new(gh, config["github"])
  end

  # PullRequest#retrieve
  def test_retrieve_sets_data_attribute
    VCR.use_cassette "github_pulls" do
      before = @pr.count
      after  = @pr.retrieve.count
      refute_equal before, after
    end
  end

  def test_retrieve_returns_pull_request_instance
    VCR.use_cassette "github_pulls" do
      assert_instance_of Rick::PullRequest, @pr.retrieve
    end
  end

  # PullRequest#under_review
  def test_under_review_sets_data_with_pull_requests_under_review
    VCR.use_cassette "github_projects" do
      prs_under_review = 5
      assert_equal prs_under_review, @pr.retrieve.under_review.count
    end
  end

  def test_under_review_returns_pull_request_instance
    VCR.use_cassette "github_projects" do
      assert_instance_of Rick::PullRequest, @pr.under_review
    end
  end

  # PullRequest#old
  def test_old_sets_data_with_pull_requests_with_no_activity_since_the_given_number_of_day
    VCR.use_cassette "github_projects", record: :new_episodes do
      prs_since_two_days = 0
      travel_to DateTime.new(2017, 12, 25) do
        assert_equal prs_since_two_days, @pr.retrieve.under_review.old.count
      end
    end

    VCR.use_cassette "github_projects" do
      prs_since_five_days = 0
      travel_to DateTime.new(2017, 12, 25) do
        assert_equal prs_since_five_days, @pr.retrieve.under_review.old(3).count
      end
    end
  end

  def test_old_returns_pull_request_instance
    assert_instance_of Rick::PullRequest, @pr.old
  end

  # PullRequest#total_off_days
  def test_total_off_days_returns_total_off_days
    from = DateTime.new(2017, 12, 15)
    to = DateTime.new(2017, 12, 18)
    assert_equal @pr.total_off_days(from, to), 2
  end

  # PullRequest#without_changelog_update
  def test_without_changelog_update_returns_pull_requests_without_changelog_update
    prs_without_changelog_update = 14
    VCR.use_cassette "github_pulls" do
      assert_equal prs_without_changelog_update, @pr.retrieve.without_changelog_update.count
    end
  end
end
