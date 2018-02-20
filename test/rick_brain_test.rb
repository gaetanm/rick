require "test_helper"

class RickBrainTest < ActiveSupport::TestCase
  def test_summarize_returns_summary_about_pull_requests
    VCR.use_cassette "github" do
      msg = "Wubba Lubba dub-dub!\n"
      msg += "PR(s) en cours de relecture : 5\n"
      msg += "PR(s) abandonnée(s) depuis au moins 2 jours : 0\n"
      msg += "PR(s) avec oubli de màj du CHANGELOG : 3\n"
      msg += "\tFeature/saml post 154980256 -> https://github.com/Keycoopt/Keybab/pull/1401\n"
      msg += "\tLes réponses aux questions sont obligatoires pour SelfApplication -> https://github.com/Keycoopt/Keybab/pull/1394\n"
      msg += "\tAnonymisation des données des membres -> https://github.com/Keycoopt/Keybab/pull/1391\n"
      msg += "Histoire(s) en attente de recette: 0\n"

      travel_to DateTime.new(2017, 12, 15) do
        assert_equal Rick::RickBrain.instance.summarize, msg
      end
    end
  end
end
