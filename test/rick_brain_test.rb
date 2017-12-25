require "test_helper"

class RickBrainTest < ActiveSupport::TestCase
  def test_summarize_returns_summary_about_pull_requests
    VCR.use_cassette "github" do
      msg = "Wubba Lubba dub-dub!\n"
      msg += "PR(s) en cours de relecture : 8\n"
      msg += "PR(s) abandonnée(s) depuis au moins 2 jours : 0\n"
      # msg += "\tOn peut modifier le statut d'un candidat recruté -> https://github.com/Keycoopt/Keybab/pull/1319\n"
      # msg += "\tJardinage -> https://github.com/Keycoopt/Keybab/pull/1307\n"
      # msg += "\tSépare fermeture d'annonce et recrutement -> https://github.com/Keycoopt/Keybab/pull/1263\n"
      # msg += "\tAjoute une tache pour effacer régulièrement les fichiers temporaires de CarrierWave -> https://github.com/Keycoopt/Keybab/pull/1156\n"
      # msg += "\tDéplace le fichier de config custom_segments_locales.yml du setup de l'app -> https://github.com/Keycoopt/Keybab/pull/1155\n"
      # msg += "\tFeature/login via username 149953974 -> https://github.com/Keycoopt/Keybab/pull/1152\n"
      msg += "Histoire(s) en attente de recette: 0\n"

      travel_to DateTime.new(2017, 12, 15) do
        assert_equal Rick::RickBrain.instance.summarize, msg
      end
    end
  end
end
