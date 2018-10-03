class PokemonBattle < ApplicationRecord
    belongs_to :pokemon1, class_name: "Pokemon", foreign_key: "pokemon1_id"
    belongs_to :pokemon2, class_name: "Pokemon", foreign_key: "pokemon2_id"
    belongs_to :winner, class_name: "Pokemon", foreign_key: "pokemon_winner_id", optional: true
    belongs_to :loser, class_name: "Pokemon", foreign_key: "pokemon_loser_id", optional: true

    validate :same_pokemon
    private
    def same_pokemon
        if pokemon1_id == pokemon2_id
            errors.add(:base, " Pokemon2 can't be same with Pokemon1")
        end
    end
end
