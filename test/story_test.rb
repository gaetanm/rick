require "test_helper"

class StoryTest < ActiveSupport::TestCase

  def setup
    config = Rick.config
    pivotal = TrackerApi::Client.new(token: config["pivotal"]["token"])
    @story = Rick::Story.new(pivotal, config["pivotal"])
  end

  # Story#retrieve
  def test_retrieve_sets_data_attribute
    VCR.use_cassette "pivotal_stories" do
      before = @story.count
      after  = @story.retrieve.count
      refute_equal before, after
    end
  end

  def test_retrieve_returns_story_instance
    VCR.use_cassette "pivotal_stories" do
      assert_instance_of Rick::Story, @story.retrieve
    end
  end

  # Story#with_state
  def test_with_state_sets_data_with_stories_having_the_given_state
    VCR.use_cassette "pivotal_stories" do
      stories_unstarted = 3
      assert_equal stories_unstarted, @story.retrieve.with_state("unstarted").count
    end
  end

  def test_with_state_returns_story_instance
    VCR.use_cassette "pivotal_stories" do
      assert_instance_of Rick::Story, @story.with_state
    end
  end
end
