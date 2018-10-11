module PokemonEvolution

    Stats = Struct.new(:health, :attack, :defence, :speed)

    def self.evolve?(pokemon_battle_id, pokemon1_level, pokemon2_level)
        @pokemon_battle = PokemonBattle.find(pokemon_battle_id)
        if !@pokemon_battle.pokemon_winner_id.nil?
            @pokemon_winner = Pokemon.find(@pokemon_battle.pokemon_winner_id)
            @evolve_to = EvolutionList.find_by(pokedex_from_name: @pokemon_winner.pokedex.name)
            if @evolve_to.present?
                if @pokemon_battle.pokemon_winner_id == @pokemon_battle.pokemon1_id
                    level_before = pokemon1_level
                else
                    level_before = pokemon2_level
                end
                @evolve_level = @evolve_to.level
                if @pokemon_winner.level >= @evolve_level && @pokemon_winner.level != level_before
                    return true
                end
            end
        end
        false
    end

    def self.calculate_evolve_extra_stats(pokedex_before_evolve_id, pokedex_after_evolve_id)
        pokedex_before_evolve = Pokedex.find(pokedex_before_evolve_id)
        pokedex_after_evolve = Pokedex.find(pokedex_after_evolve_id)
        health = pokedex_after_evolve.base_health_point - pokedex_before_evolve.base_health_point
        attack = pokedex_after_evolve.base_attack - pokedex_before_evolve.base_attack
        defence = pokedex_after_evolve.base_defence - pokedex_before_evolve.base_defence
        speed = pokedex_after_evolve.base_speed - pokedex_before_evolve.base_speed
        stats = Stats.new(health, attack, defence, speed)
        stats
    end

end