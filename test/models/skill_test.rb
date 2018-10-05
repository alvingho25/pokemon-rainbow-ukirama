require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  def setup
    @skill = Skill.new(
      name: "Scorching Fire",
      power: 500,
      max_pp: 50,
      element_type: "fire"
    )
  end

  test "element type inclusion is not valid" do
    @skill.element_type = "Dragon"
    assert_not @skill.valid?, "#{@skill.element_type} should not be valid element"
    
    @skill.element_type = "unkwon"
    assert_not @skill.valid?, "#{@skill.element_type} should not be valid element"
  end

  test "element type inclusion is valid" do
    @skill.element_type = "fire"
    assert @skill.valid?, "#{@skill.element_type} should be valid element"
  end

  test "name is not valid" do
    @skill.name = ""
    assert_not @skill.valid?, "skill name should not be null"

    @skill.name = "a" * 50
    assert_not @skill.valid?, "skill name length should not be greater than 45"

    @skill_2 = @skill.dup
    assert_not @skill_2.valid?, "skill name should be unique"
  end

  test "name is valid" do
    @skill.name = "Scorching Fire"
    assert @skill.valid?, "skill name should be valid"

    @skill.name = "a" * 45
    assert @skill.valid?, "skill name should be valid"
  end

  test "power is not valid" do
    @skill.power = 0
    assert_not @skill.valid?, "skill power should be greater than 0"

    @skill.power = -10
    assert_not @skill.valid?, "skill power should be greater than 0"

    @skill.power = "a"
    assert_not @skill.valid?, "skill power should not be string"
  end

  test "power is valid" do
    @skill.power = "500"
    assert @skill.valid?, "skill power should be valid"
  end

  test "max pp is not valid" do
    @skill.max_pp = 0
    assert_not @skill.valid?, "skill max_pp should be greater than 0"

    @skill.max_pp = -10
    assert_not @skill.valid?, "skill max_pp should be greater than 0"

    @skill.max_pp = "a"
    assert_not @skill.valid?, "skill max_pp should not be string"
  end

  test "max pp is valid" do
    @skill.max_pp = "50"
    assert @skill.valid?, "skill max_pp should be valid"
  end

end
