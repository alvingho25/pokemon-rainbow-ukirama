require 'test_helper'

class AiEngineLogicTest < ActiveSupport::TestCase
    def setup
        @pokedex = Pokedex.new(
            name: "charmander",
            base_health_point: 45,
            base_attack: 49,
            base_defence: 49,
            base_speed: 45,
            element_type: "fire",
            image_url: "https://img.pokemondb.net/artwork/charmander.jpg"
          )
          @pokedex.save
          @skill = Skill.new(
            name: "Scorching Fire",
            power: 500,
            max_pp: 50,
            element_type: "fire"
          )
          @skill.save
          @pokemon1 = Pokemon.new(
            name: "alvin",
            pokedex_id: @pokedex.id,
            level: 1,
            max_health_point: 45,
            current_health_point: 45,
            attack: 49,
            defence: 49,
            speed: 45,
            current_experience: 0
          )
          @pokemon1.save
          @pokemon2 = Pokemon.new(
            name: "huolong",
            pokedex_id: @pokedex.id,
            level: 1,
            max_health_point: 45,
            current_health_point: 45,
            attack: 49,
            defence: 49,
            speed: 45,
            current_experience: 0
          )
          @pokemon2.save
          @pokemon_skill = PokemonSkill.new(
            skill_id: @skill.id,
            pokemon_id: @pokemon1.id,
            current_pp: @skill.max_pp
          )
          @pokemon_skill.save
          @pokemon_skill2 = PokemonSkill.new(
            skill_id: @skill.id,
            pokemon_id: @pokemon2.id,
            current_pp: @skill.max_pp
          )
          @pokemon_skill2.save
          @pokemon_battle = PokemonBattle.new(
            pokemon1_id: @pokemon1.id,
            pokemon2_id: @pokemon2.id,
            current_turn: 1,
            state: 'On Going',
            experience_gain: 0,
            pokemon1_max_health_point: @pokemon1.max_health_point,
            pokemon2_max_health_point: @pokemon2.max_health_point,
            battle_type: 'Manual'
          )
          @pokemon_battle.save
    end

    test "pokemon battle vs AI should increase turn by 2" do
        @pokemon_battle.battle_type = 'vs AI'
        current_hp = @pokemon_battle.pokemon2.current_health_point
        current_turn = @pokemon_battle.current_turn
        current_pp = @pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @pokemon_skill.skill_id).current_pp
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_operator pokemon_battle.pokemon2.current_health_point, :< , current_hp, "Pokemon 2 current HP should not be equal to pokemon 2 max hp" 
        assert_equal current_turn + 1, pokemon_battle.current_turn, "Pokemon battle current turn should increase by 1"
        assert_equal current_pp - 1, pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @pokemon_skill.skill_id).current_pp, "Pokemon 1 skill should decrease by 1"
    
        current_hp = pokemon_battle.pokemon1.current_health_point
        current_turn = pokemon_battle.current_turn
        current_pp = pokemon_battle.pokemon2.pokemon_skills.find_by(skill_id: @pokemon_skill2.skill_id).current_pp

        AiEngine.ai_turn(pokemon_battle.id)
        pokemon_battle.reload

        assert_operator pokemon_battle.pokemon1.current_health_point, :<, current_hp, "Pokemon 1 current HP should not be equal to pokemon 1 max hp"
        assert_equal current_turn + 1, pokemon_battle.current_turn, "Pokemon battle current turn should increase by 1 to 2"
        assert_equal current_pp - 1, pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @pokemon_skill2.skill_id).current_pp, "Pokemon 2 skill should decrease by 1"
    end

    test "pokemon auto battle should finish the battle and have a winner" do
        @pokemon_battle.battle_type = 'Auto'
        AiEngine.auto_battle(@pokemon_battle.id)
        @pokemon_battle.reload
        assert_equal 'Finished', @pokemon_battle.state, "Pokemon auto battle should be finished"
        assert_not_nil @pokemon_battle.pokemon_winner_id, "Pokemon auto battle should have winner"
        assert_not_nil @pokemon_battle.pokemon_loser_id, "Pokemon auto battle should have loser"
        assert_not_equal 0, @pokemon_battle.experience_gain, "Pokemon auto battle should have experience gain"
        assert_operator @pokemon_battle.current_turn, :>, 1, "Pokemon auto battle turn should be increasing"
    end
end