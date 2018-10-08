class BattleEngine
    def initialize(battle_id:, skill_id:, pokemon_id:, action:)
        @pokemon_battle = PokemonBattle.find(battle_id)
        @skill_id = skill_id
        @pokemon_id = pokemon_id

        current_turn = @pokemon_battle.current_turn
        if current_turn % 2 != 0
            @attacker = @pokemon_battle.pokemon1
            @defender = @pokemon_battle.pokemon2
        else
            @attacker = @pokemon_battle.pokemon2
            @defender = @pokemon_battle.pokemon1
        end
        @action = action
    end

    def valid_next_turn?
        if @pokemon_id == @attacker.id
            return true
        end
        false
    end

    def next_turn!
        if @action == 'Attack'
            if @attacker.pokemon_skills.find_by(skill_id: @skill_id).nil?
                return false
            else
                @pokemon_skill = @attacker.pokemon_skills.find_by(skill_id: @skill_id)
                if @pokemon_skill.current_pp == 0
                    return false
                else
                    damage = PokemonBattleCalculator.calculate_damage(@attacker, @defender, @pokemon_skill.skill_id)
                    @defender.current_health_point = @defender.current_health_point - damage
                    if @defender.current_health_point <= 0
                        @defender.current_health_point = 0
                    end
                    @logs = PokemonBattleLog.new(
                        pokemon_battle_id: @pokemon_battle.id,
                        turn: @pokemon_battle.current_turn,
                        skill_id: @pokemon_skill.skill_id,
                        damage: damage,
                        attacker_id: @attacker.id,
                        attacker_current_health_point: @attacker.current_health_point,
                        defender_id: @defender.id,
                        defender_current_health_point: @defender.current_health_point,
                        action_type: @action
                    )
                    if @defender.current_health_point == 0
                        @pokemon_battle.pokemon_winner_id = @attacker.id
                        @pokemon_battle.pokemon_loser_id = @defender.id
                        @pokemon_battle.state = 'Finished'

                        experience = PokemonBattleCalculator.calculate_experience(@defender)
                        @pokemon_battle.experience_gain = experience
                        @attacker.current_experience = @attacker.current_experience + experience
                        @attacker = leveling_up(@attacker)
                    else
                        @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1
                    end
                    @pokemon_skill.current_pp = @pokemon_skill.current_pp - 1
                end
            end
        else
            @logs = PokemonBattleLog.new(
                pokemon_battle_id: @pokemon_battle.id,
                turn: @pokemon_battle.current_turn,
                attacker_id: @attacker.id,
                attacker_current_health_point: @attacker.current_health_point,
                defender_id: @defender.id,
                defender_current_health_point: @defender.current_health_point,
                action_type: @action
            )
            @pokemon_battle.pokemon_winner_id = @defender.id
            @pokemon_battle.pokemon_loser_id = @attacker.id
            @pokemon_battle.state = 'Finished'

            experience = PokemonBattleCalculator.calculate_experience(@attacker)
            @pokemon_battle.experience_gain = experience
            @defender.current_experience = @defender.current_experience + experience
            @defender = leveling_up(@defender)
        end
        true
    end

    def save!
        @pokemon_battle.save!
        @attacker.save!
        @defender.save!
        @logs.save!
        if !@pokemon_skill.nil?
            @pokemon_skill.save!
        end
    end

    private
    def leveling_up(winner)
        while PokemonBattleCalculator.level_up?(winner.level, winner.current_experience)
            winner.level = winner.level + 1

            stats = PokemonBattleCalculator.calculate_level_up_extra_stats
            winner.max_health_point = winner.max_health_point + stats.health
            winner.attack = winner.attack + stats.attack
            winner.defence = winner.defence + stats.defence
            winner.speed = winner.speed + stats.speed
        end
        winner
    end
end