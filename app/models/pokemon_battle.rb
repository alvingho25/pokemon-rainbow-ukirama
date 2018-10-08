class PokemonBattle < ApplicationRecord
    belongs_to :pokemon1, class_name: "Pokemon", foreign_key: "pokemon1_id"
    belongs_to :pokemon2, class_name: "Pokemon", foreign_key: "pokemon2_id"
    belongs_to :winner, class_name: "Pokemon", foreign_key: "pokemon_winner_id", optional: true
    belongs_to :loser, class_name: "Pokemon", foreign_key: "pokemon_loser_id", optional: true

    has_many :logs, class_name: "PokemonBattleLog", foreign_key: "pokemon_battle_id", dependent: :destroy

    validate :same_pokemon
    validate :pokemon_health, on: :create

    private
    def same_pokemon
        if pokemon1_id == pokemon2_id
            errors.add(:base, " Pokemon2 can't be same with Pokemon1")
        end
    end

    def pokemon_health
        if Pokemon.exists?(pokemon1_id) && Pokemon.exists?(pokemon2_id)
            @pokemon1 = Pokemon.find(pokemon1_id)
            @pokemon2 = Pokemon.find(pokemon2_id)
            if @pokemon1.current_health_point == 0 
                errors.add(:base, " Pokemon1 can't have 0 health to battle")
            end
            if @pokemon2.current_health_point == 0
                errors.add(:base, " Pokemon2 can't have 0 health to battle")
            end
        else  
            errors.add(:base, " Pokemon Not Found")
        end
    end
end
