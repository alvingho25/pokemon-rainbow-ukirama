module AiEngine
    def self.auto_battle(battle)
        @pokemon_battle = PokemonBattle.find(battle)
        while @pokemon_battle.pokemon_winner_id.nil?
            @turn = @pokemon_battle.current_turn
            if @turn % 2 != 0
                @pokemon = @pokemon_battle.pokemon1
            else
                @pokemon = @pokemon_battle.pokemon2
            end
            @skills = @pokemon.pokemon_skills.select{ |skill| skill.current_pp > 0}
            @skill = @skills.sample
            if @skill.nil?
                @action = 'Surrender'
                @skill_id = nil
            else
                @action = 'Attack'
                @skill_id = @skill.skill_id
            end
            battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id,pokemon_id: @pokemon.id, skill_id: @skill_id, action: @action)
            if battle_engine.valid_next_turn?
                if battle_engine.next_turn!
                    battle_engine.save!
                end
            end
            @pokemon_battle = PokemonBattle.find(battle)
        end
    end

    def self.my_turn(battle)
        @pokemon_battle = PokemonBattle.find(battle)
        @pokemon = @pokemon_battle.pokemon2
        @skills = @pokemon.pokemon_skills.select{ |skill| skill.current_pp > 0}
        @skill = @skills.sample
        if @skill.nil?
            @action = 'Surrender'
            @skill_id = nil
        else
            @action = 'Attack'
            @skill_id = @skill.skill_id
        end
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id,pokemon_id: @pokemon.id, skill_id: @skill_id, action: @action)
        if battle_engine.valid_next_turn?
            if battle_engine.next_turn!
                battle_engine.save!
            end
        end
    end
end