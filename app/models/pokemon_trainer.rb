class PokemonTrainer < ApplicationRecord
    belongs_to :trainer
    belongs_to :pokemon

    validate :same_pokemon
    validate :five_pokemon

    def win_rate
        sql = "
            select case
                when battle > 0 then win*100/battle
                else 0
                end
                as \"Win_Rate\"
            from 
                pokemon_trainers
            where
                id = #{id}"
        win_rate = ActiveRecord::Base.connection.execute(sql)
        win_rate = win_rate.values[0][0]
    end

    private
    def same_pokemon
        @used_pokemons = PokemonTrainer.all.map { |pokemon| pokemon.pokemon_id }
        if @used_pokemons.include?(pokemon_id)
            errors.add(:base, " Pokemon can't have 2 or more trainer")
        end
    end

    def five_pokemon
        @count = PokemonTrainer.where(trainer_id: trainer_id).count
        if @count == 5
            errors.add(:base, " Trainer can't have more than 5 pokemon")
        end
    end
end
