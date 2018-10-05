require 'test_helper'

class PokemonTest < ActiveSupport::TestCase
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
  end

  test "pokemon name should not be greater than 45" do
    @pokemon.name = "a" * 50
    assert_not @pokemon.valid?, "pokemon name should not be greater than 45"
  end

  test "pokemon name should not be null" do
    @pokemon.name = ""
    assert_not @pokemon.valid?, "pokemon name should not be null"
  end

  test "pokemon name should not have same name" do
    pokemon_2 = @pokemon.dup
    @pokemon.save
    assert_not pokemon_2.valid?, "pokemon name should not have same name"
  end

  test "pokemon name should be valid" do
    assert @pokemon.valid?, "pokemon name should be valid"
  end

  test "pokemon name should be less or equal to 45" do
    @pokemon.name = "a" * 45
    assert @pokemon.valid?, "pokemon name should be less or equal to 45"
  end

  test "pokemon name should be unique" do
    pokemon_2 = @pokemon.dup
    pokemon_2.name = "Duplicated"
    assert pokemon_2.valid?, "pokemon name should be valid and unique"
  end

  test "pokemon max health point should not be less or equal 0" do
    @pokemon.max_health_point = 0
    assert_not @pokemon.valid?, "pokemon max health point should not be 0"

    @pokemon.max_health_point = -10
    assert_not @pokemon.valid?, "pokemon max health point should not be less than 0"
  end

  test "pokemon max health point should not be string" do
    @pokemon.max_health_point = "a"
    assert_not @pokemon.valid?, "pokemon max health point should not be string"
  end

  test "pokemon max health point should be valid" do
    @pokemon.max_health_point = 500
    assert @pokemon.valid?, "pokemon max health point should be valid"
  end

  test "pokemon current health point should not be less than 0" do
    @pokemon.current_health_point = -10
    assert_not @pokemon.valid?, "pokemon current health point should not be less than 0"
  end

  test "pokemon current health point should not be string" do
    @pokemon.current_health_point = "a"
    assert_not @pokemon.valid?, "pokemon current health point should not be string"
  end

  test "pokemon current health point should be greater or equal to 0" do
    @pokemon.current_health_point = 0
    assert @pokemon.valid?, "pokemon current health point should be 0"
  end

  test "pokemon current health point should not be greater than max health point" do
    @pokemon.max_health_point = 25
    @pokemon.current_health_point = 50
    assert_not @pokemon.valid?, "pokemon current health point should not be greater than pokemon max health point"

    @pokemon.max_health_point = nil
    @pokemon.current_health_point = 50
    assert_not @pokemon.valid?, "pokemon current health point should not be greater than pokemon max health point"
  end

  test "pokemon current health point should be less or equal to max health point" do
    @pokemon.max_health_point = 50
    @pokemon.current_health_point = 50
    assert @pokemon.valid?, "pokemon current health point should be less or euqal to pokemon max health point"
  end

  test "pokemon current experience should not be less than 0" do
    @pokemon.current_experience = -10
    assert_not @pokemon.valid?, "pokemon current experience should not be less than 0"
  end

  test "pokemon current experience should not be string" do
    @pokemon.current_experience = "a"
    assert_not @pokemon.valid?, "pokemon current experience should not be string"
  end

  test "pokemon current experience should be valid" do
    @pokemon.current_experience = 500
    assert @pokemon.valid?, "pokemon current experience should be valid"

    @pokemon.current_experience = 0
    assert @pokemon.valid?, "pokemon current experience should be valid 0"
  end

  test "pokemon attack should not be less or equal 0" do
    @pokemon.attack = 0
    assert_not @pokemon.valid?, "pokemon attack should not be 0"

    @pokemon.attack = -10
    assert_not @pokemon.valid?, "pokemon attack should not be less than 0"
  end

  test "pokemon attack should not be string" do
    @pokemon.attack = "a"
    assert_not @pokemon.valid?, "pokemon attack should not be string"
  end

  test "pokemon attack is valid" do
    @pokemon.attack = 500
    assert @pokemon.valid?, "pokemon attack should be valid"
  end

  test "pokemon defence should not be less or equal 0" do
    @pokemon.defence = 0
    assert_not @pokemon.valid?, "pokemon defence should not be 0"

    @pokemon.defence = -10
    assert_not @pokemon.valid?, "pokemon defence should not be less than 0"
  end

  test "pokemon defence should not be string" do
    @pokemon.defence = "a"
    assert_not @pokemon.valid?, "pokemon defence should not be string"
  end

  test "pokemon defence is valid" do
    @pokemon.defence = 500
    assert @pokemon.valid?, "pokemon defence should be valid"
  end

  test "pokemon speed should not be less or equal 0" do
    @pokemon.speed = 0
    assert_not @pokemon.valid?, "pokemon speed should not be 0"

    @pokemon.speed = -10
    assert_not @pokemon.valid?, "pokemon speed should not be less than 0"
  end

  test "pokemon speed should not be string" do
    @pokemon.speed = "a"
    assert_not @pokemon.valid?, "pokemon speed should not be string"
  end

  test "pokemon speed is valid" do
    @pokemon.speed = 500
    assert @pokemon.valid?, "pokemon speed should be valid"
  end

  test "pokemon level should not be less or equal 0" do
    @pokemon.level = 0
    assert_not @pokemon.valid?, "pokemon level should not be 0"

    @pokemon.level = -10
    assert_not @pokemon.valid?, "pokemon level should not be less than 0"
  end

  test "pokemon level should not be string" do
    @pokemon.level = "a"
    assert_not @pokemon.valid?, "pokemon level should not be string"
  end

  test "pokemon level is valid" do
    @pokemon.level = 500
    assert @pokemon.valid?, "pokemon level should be valid"
  end
end
