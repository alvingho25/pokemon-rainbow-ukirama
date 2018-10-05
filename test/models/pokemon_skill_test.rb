require 'test_helper'

class PokemonSkillTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(
      name: "charmander",
      base_health_point: 45,
      base_attack: 49,
      base_defence: 49,
      base_speed: 45,
      element_type: "fire",
      image_url: "https://img.pokemondb.net/artwork/salamence.jpg"
    )
    @pokedex.save
    @pokemon = Pokemon.new(
      name: "Alvin",
      pokedex_id: @pokedex.id,
      level: 1,
      max_health_point: 45,
      current_health_point: 45,
      attack: 49,
      defence: 49,
      speed: 45,
      current_experience: 0
    )
    @pokemon.save
    @skill = Skill.new(
      name: "Scorching Fire",
      power: 500,
      max_pp: 50,
      element_type: "fire"
    )
    @skill.save
    @pokemon_skill = PokemonSkill.new(
      skill_id: @skill.id,
      pokemon_id: @pokemon.id,
      current_pp: @skill.max_pp
    )
  end

  test "pokemon should not have 2 same skill" do
    @pokemon_skill.save
    pokemon_skill_2 = @pokemon_skill.dup
    assert_not pokemon_skill_2.valid?, "pokemon should not have 2 same skill"
  end

  test "pokemon skill should be valid" do
    assert @pokemon_skill.valid?, "pokemon skill should be valid"
  end

  test "pokemon should not have skill with other element type" do
    @skill.element_type = "grass"
    @skill.save
    assert_not @pokemon_skill.valid?, "pokemon should not have skill with other element type"
  end

  test "pokemon should have skill with same element type" do
    @skill.element_type = "grass"
    @skill.save
    @pokedex.element_type = "grass"
    @pokedex.save
    assert @pokemon_skill.valid?, "pokemon should have skill with same element type"
  end

  test "pokemon skill current pp should not be greater than skill max pp" do
    @skill.max_pp = 10
    @skill.save
    @pokemon_skill.current_pp = 15
    assert_not @pokemon_skill.valid?, "pokemon skill current pp should not be greater than skill max pp"
  end

  test "pokemon current pp should not be less than 0" do
    @pokemon.current_pp = -10
    assert_not @pokemon.valid?, "pokemon current pp should not be less than 0"
  end

  test "pokemon current pp should not be string" do
    @pokemon.current_pp = "a"
    assert_not @pokemon.valid?, "pokemon current pp should not be string"
  end

  test "pokemon current pp is valid" do
    @pokemon.current_pp = 500
    assert @pokemon.valid?, "pokemon current pp should be valid"

    @pokemon.current_pp = 0
    assert @pokemon.valid?, "pokemon current pp should be valid 0"
  end
end
