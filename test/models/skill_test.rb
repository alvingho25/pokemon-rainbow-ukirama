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

  test "skill name should not be null" do
    @skill.name = ""
    assert_not @skill.valid?, "skill name should not be null"
  end

  test "skill name should not be greater than 45" do
    @skill.name = "a" * 50
    assert_not @skill.valid?, "skill name length should not be greater than 45"
  end

  test "skill name should not have same name" do
    skill_2 = @skill.dup
    @skill.save
    assert_not skill_2.valid?, "skill name should be unique"
  end

  test "skill name should be valid" do
    @skill.name = "Scorching Fire"
    assert @skill.valid?, "skill name should be valid"
  end

  test "skill name should be less or equal than 45" do
    @skill.name = "a" * 45
    assert @skill.valid?, "skill name should be valid"
  end

  test "skill name should be unique" do
    skill_2 = @skill.dup
    skill_2.name = "Duplicated"
    assert @skill.valid?, "skill name should valid and unique"
  end

  test "skill power should not be less or equal than 0" do
    @skill.power = 0
    assert_not @skill.valid?, "skill power should not be 0"

    @skill.power = -10
    assert_not @skill.valid?, "skill power should not be less than 0"
  end

  test "skill power should not be string" do
    @skill.power = "a"
    assert_not @skill.valid?, "skill power should not be string"
  end

  test "skill power should be valid" do
    @skill.power = "500"
    assert @skill.valid?, "skill power should be valid"
  end

  test "skill max pp should not be less or equal than 0" do
    @skill.max_pp = 0
    assert_not @skill.valid?, "skill max_pp should not be 0"

    @skill.max_pp = -10
    assert_not @skill.valid?, "skill max_pp should not be less than 0"
  end

  test "skill max pp should not be string" do
    @skill.max_pp = "a"
    assert_not @skill.valid?, "skill max_pp should not be string"
  end

  test "skill max pp should be valid" do
    @skill.max_pp = "50"
    assert @skill.valid?, "skill max_pp should be valid"
  end
end
