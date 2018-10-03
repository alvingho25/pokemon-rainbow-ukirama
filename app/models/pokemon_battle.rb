class PokemonBattle < ApplicationRecord
    belongs_to :pokemon1, class_name: "Pokemon", foreign_key: "pokemon1_id"
    belongs_to :pokemon2, class_name: "Pokemon", foreign_key: "pokemon2_id"
    belongs_to :winner, class_name: "Pokemon", foreign_key: "pokemon_winner_id", optional: true
    belongs_to :loser, class_name: "Pokemon", foreign_key: "pokemon_loser_id", optional: true
end
