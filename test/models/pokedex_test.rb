require 'test_helper'

class PokedexTest < ActiveSupport::TestCase
  def setup
    @pokedex = Pokedex.new(
      name: "Alvin",
      base_health_point: 500,
      base_attack: 500,
      base_defence: 500,
      base_speed: 500,
      element_type: "dragon",
      image_url: "https://img.pokemondb.net/artwork/salamence.jpg"
    )
  end

  test "element type inclusion is not valid" do
    @pokedex.element_type = "Dragon"
    assert_not @pokedex.valid?, "#{@pokedex.element_type} should not be valid element"
    
    @pokedex.element_type = "unkwon"
    assert_not @pokedex.valid?, "#{@pokedex.element_type} should not be valid element"
  end

  test "element type inclusion is valid" do
    @pokedex.element_type = "fire"
    assert @pokedex.valid?, "#{@pokedex.element_type} should be valid element"
  end

  test "pokedex name should not be null" do
    @pokedex.name = ""
    assert_not @pokedex.valid?, "Pokedex name should not be null"
  end

  test "pokedex name length should not be greater than 45" do
    @pokedex.name = "a" * 50
    assert_not @pokedex.valid?, "Pokedex name length should not be greater than 45"
  end

  test "pokedex name should not have same name" do
    pokedex_2 = @pokedex.dup
    @pokedex.save
    assert_not pokedex_2.valid?, "Pokedex name should be unique"
  end

  test "pokedex name should be valid" do
    @pokedex.name = "Alvin"
    assert @pokedex.valid?, "Pokedex name should be valid"
  end

  test "pokedex name should be less or equal to 45" do
    @pokedex.name = "a" * 45
    assert @pokedex.valid?, "Pokedex name should be valid"
  end

  test "pokedex name should be unique" do
    pokedex_2 = @pokedex.dup
    pokedex_2.name = "Duplicated"
    assert pokedex_2.valid?, "Pokedex name should be valid and unique"
  end

  test "pokedex base health point should not be less or equal 0" do
    @pokedex.base_health_point = 0
    assert_not @pokedex.valid?, "Pokedex base health point should not be 0"

    @pokedex.base_health_point = -10
    assert_not @pokedex.valid?, "Pokedex base health point should not be less than 0"
  end

  test "pokedex base health point should not be string" do
    @pokedex.base_health_point = "a"
    assert_not @pokedex.valid?, "Pokedex base health point should not be string"
  end

  test "pokedex base health point should be valid" do
    @pokedex.base_health_point = "500"
    assert @pokedex.valid?, "Pokedex base health point should be valid"
  end

  test "pokedex base attack should not be less or equal 0" do
    @pokedex.base_attack = 0
    assert_not @pokedex.valid?, "Pokedex base attack should not be 0"

    @pokedex.base_attack = -10
    assert_not @pokedex.valid?, "Pokedex base attack should not be less than 0"
  end

  test "pokedex base attack should not be string" do
    @pokedex.base_attack = "a"
    assert_not @pokedex.valid?, "Pokedex base attack should not be string"
  end

  test "pokedex base attack is valid" do
    @pokedex.base_attack = 500
    assert @pokedex.valid?, "Pokedex base attack should be valid"
  end

  test "pokedex base defence should not be less or equal 0" do
    @pokedex.base_defence = 0
    assert_not @pokedex.valid?, "Pokedex base defence should not be 0"

    @pokedex.base_defence = -5
    assert_not @pokedex.valid?, "Pokedex base defence should not be less than 0"
  end

  test "pokedex base defence should not be string" do
    @pokedex.base_defence = "a"
    assert_not @pokedex.valid?, "Pokedex base defence should not be string"
  end

  test "pokedex base defence should be valid" do
    @pokedex.base_defence = 500
    assert @pokedex.valid?, "Pokedex base defence should be valid"
  end

  test "pokedex base speed should not be less or equal 0" do
    @pokedex.base_speed = 0
    assert_not @pokedex.valid?, "Pokedex base speed should not be 0"

    @pokedex.base_speed = -5
    assert_not @pokedex.valid?, "Pokedex base speed should not be less than 0"
  end

  test "pokedex base speed should not be string" do
    @pokedex.base_speed = "a"
    assert_not @pokedex.valid?, "Pokedex base speed should not be string"
  end

  test "pokedexbase speed should be valid" do
    @pokedex.base_speed = 500
    assert @pokedex.valid?, "Pokedex base speed should be valid"
  end

end
