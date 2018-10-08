require 'test_helper'

class BattleEngineLogicTest < ActiveSupport::TestCase
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
            pokemon2_max_health_point: @pokemon2.max_health_point
          )
          @pokemon_battle.save
    end

    test "pokemon battle should be valid" do
        assert @pokemon_battle.valid?, "pokemon battle should be valid"
    end

    test "pokemon battle valid move on turn" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill.skill_id, action: 'Attack')
        assert battle_engine.valid_next_turn?, "pokemon battle should have valid turn"
    end

    test "pokemon battle not valid move on turn" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon2.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        assert_not battle_engine.valid_next_turn?, "pokemon battle should have valid turn"
    end

    test "pokemon battle cannot attack with 0 pp skill" do
        @pokemon_skill.current_pp = 0
        @pokemon_skill.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill.skill_id, action: 'Attack')
        assert_not battle_engine.next_turn!, "pokemon battle should not attack because of 0 pp skill"
    end

    test "pokemon battle should be attack with greater than 0 pp skill" do
        @pokemon_skill.current_pp = 5
        @pokemon_skill.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill.skill_id, action: 'Attack')
        assert battle_engine.next_turn!, "pokemon battle should be attack with greater than 0 pp skill"
    end

    test "pokemon battle should have valid skill to attack" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill.skill_id, action: 'Attack')
        assert battle_engine.next_turn!, "pokemon battle should have valid skill to attack"
    end

    test "pokemon battle should not have valid skill to attack" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        assert battle_engine.next_turn!, "pokemon battle should not have valid skill to attack"
    end

    test "pokemon battle valid attack" do
        current_hp = @pokemon_battle.pokemon2.current_health_point
        current_turn = @pokemon_battle.current_turn
        current_pp = @pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @pokemon_skill.skill_id).current_pp
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_not_equal current_hp, pokemon_battle.pokemon2.current_health_point, "Pokemon 2 current HP should not be equal to pokemon 2 max hp" 
        assert_equal current_turn + 1, pokemon_battle.current_turn, "Pokemon battle current turn should increase by 1"
        assert_equal current_pp - 1, pokemon_battle.pokemon1.pokemon_skills.find_by(skill_id: @pokemon_skill.skill_id).current_pp, "Pokemon 1 skill should decrease by 1"
    end

    test "pokemon battle should change state when finished" do
        @pokemon2.current_health_point = 1
        @pokemon2.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_equal 'Finished', pokemon_battle.state, "pokemon battle state should be finished"
    end

    test "pokemon surrender valid move on turn" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill.skill_id, action: 'Surrender')
        assert battle_engine.valid_next_turn?, "pokemon surrender should have valid turn"
    end

    test "pokemon surrender not valid move on turn" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon2.id, skill_id: @pokemon_skill2.skill_id, action: 'Surrender')
        assert_not battle_engine.valid_next_turn?, "pokemon surrender should have valid turn"
    end

    test "pokemon surrender should change state" do
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill.skill_id, action: 'Surrender')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_equal 'Finished', pokemon_battle.state, "pokemon battle state should be finished"
    end

    test "finished battle should determined winner and loser" do
        @pokemon2.current_health_point = 1
        @pokemon2.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_equal @pokemon1.id, pokemon_battle.pokemon_winner_id, "pokemon winner should be pokemon1"
        assert_equal @pokemon2.id, pokemon_battle.pokemon_loser_id, "pokemon winner should be pokemon2"
    end

    test "finished battle should get experience gained" do
        @pokemon2.current_health_point = 1
        @pokemon2.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_not_equal 0, pokemon_battle.experience_gain , "pokemon battle experience gain should not be 0"
    end

    test "finished battle with enough experience should leveling up 1" do
        @pokemon1.current_experience = 200
        @pokemon1.save
        @pokemon2.current_health_point = 1
        @pokemon2.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_equal 2, pokemon_battle.pokemon1.level, "pokemon 1 should be level 2"
    end

    test "finished battle with enough experience should leveling up more than 1" do
        @pokemon1.current_experience = 5000
        @pokemon1.save
        @pokemon2.current_health_point = 1
        @pokemon2.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon_battle = PokemonBattle.find(@pokemon_battle.id)
        end
        assert_operator pokemon_battle.pokemon1.level, :>, 1 , "pokemon 1 should be leveling up many times"
    end

    test "leveling up pokemon should have increased stats" do
        @pokemon1.current_experience = 5000
        @pokemon1.save
        @pokemon2.current_health_point = 1
        @pokemon2.save
        battle_engine = BattleEngine.new(battle_id: @pokemon_battle.id, pokemon_id: @pokemon_battle.pokemon1.id, skill_id: @pokemon_skill2.skill_id, action: 'Attack')
        if battle_engine.next_turn!
            battle_engine.save!
            pokemon1 = PokemonBattle.find(@pokemon_battle.id).pokemon1
        end
        assert_operator pokemon1.max_health_point, :>, @pokemon1.max_health_point , "pokemon 1 max health point should increase"
        assert_operator pokemon1.attack, :>, @pokemon1.attack , "pokemon 1 attack should increase"
        assert_operator pokemon1.defence, :>, @pokemon1.defence , "pokemon 1 defence should increase"
        assert_operator pokemon1.speed, :>, @pokemon1.speed , "pokemon 1 speed should increase"
    end
end