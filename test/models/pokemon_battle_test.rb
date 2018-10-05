require 'test_helper'

class PokemonBattleTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(
      name: "charmander",
      base_health_point: 45,
      base_attack: 49,
      base_defence: 49,
      base_speed: 45,
      element_type: "grass",
      image_url: "https://img.pokemondb.net/artwork/salamence.jpg"
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
  end

  test "pokemon battle should not have same pokemon" do
    @pokemon_battle.pokemon2_id = @pokemon1.id
    assert_not @pokemon_battle.valid?, "pokemon battle should not have same pokemon"
  end

  test "pokemon battle should have 2 different pokemon" do
    assert @pokemon_battle.valid?, "pokemon battle should have 2 different pokemon"
  end

  test "pokemon battle on create should have current health point greater than 0" do
    @pokemon1.current_health_point = 0
    @pokemon1.save
    assert_not @pokemon_battle.valid?, "pokemon 1 should not have 0 current health point"

    @pokemon2.current_health_point = 0
    @pokemon2.save
    assert_not @pokemon_battle.valid?, "pokemon 1 & 2 should not have 0 current health point"
    

    @pokemon1.current_health_point = 45
    @pokemon1.save
    assert_not @pokemon_battle.valid?, "pokemon 2 should not have 0 current health point"
  end

  test "pokemon battle with not valid pokemon should not be created" do
    @pokemon_battle.pokemon1_id = 99999
    @pokemon_battle.save
    assert_not @pokemon_battle.valid?, "pokemon battle with no valid pokemon 1 should not be created"

    @pokemon_battle.pokemon1_id = nil
    @pokemon_battle.save
    assert_not @pokemon_battle.valid?, "pokemon battle with nil pokemon 1 should not be created"

    @pokemon_battle.pokemon2_id = 9999
    @pokemon_battle.save
    assert_not @pokemon_battle.valid?, "pokemon battle with no valid pokemon 1 & 2 should not be created"

    @pokemon_battle.pokemon2_id = nil
    @pokemon_battle.save
    assert_not @pokemon_battle.valid?, "pokemon battle with nil pokemon 1 & 2 should not be created"

    @pokemon_battle.pokemon1_id = @pokemon1.id
    @pokemon_battle.save
    assert_not @pokemon_battle.valid?, "pokemon battle with nil pokemon 2 should not be created"

    @pokemon_battle.pokemon2_id = 9999
    @pokemon_battle.save
    assert_not @pokemon_battle.valid?, "pokemon battle with no valid pokemon 2 should not be created"
  end
end
