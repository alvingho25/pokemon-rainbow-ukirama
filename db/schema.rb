# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_11_014432) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "evolution_lists", force: :cascade do |t|
    t.string "pokedex_from_name"
    t.string "pokedex_to_name"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pokedexes", force: :cascade do |t|
    t.string "name"
    t.integer "base_health_point"
    t.integer "base_attack"
    t.integer "base_defence"
    t.integer "base_speed"
    t.string "element_type"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_pokedexes_on_name", unique: true
  end

  create_table "pokemon_battle_logs", force: :cascade do |t|
    t.integer "turn"
    t.integer "damage", default: 0
    t.integer "attacker_current_health_point"
    t.integer "defender_current_health_point"
    t.string "action_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pokemon_battle_id", null: false
    t.integer "skill_id"
    t.integer "attacker_id", null: false
    t.integer "defender_id", null: false
  end

  create_table "pokemon_battles", force: :cascade do |t|
    t.integer "current_turn", default: 1
    t.string "state", default: "On Going"
    t.integer "experience_gain"
    t.integer "pokemon1_max_health_point"
    t.integer "pokemon2_max_health_point"
    t.string "battle_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pokemon1_id", null: false
    t.integer "pokemon2_id", null: false
    t.integer "pokemon_winner_id"
    t.integer "pokemon_loser_id"
  end

  create_table "pokemon_skills", force: :cascade do |t|
    t.integer "current_pp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pokemon_id", null: false
    t.integer "skill_id", null: false
  end

  create_table "pokemon_trainers", force: :cascade do |t|
    t.integer "battle", default: 0
    t.integer "win", default: 0
    t.integer "lose", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "trainer_id", null: false
    t.integer "pokemon_id", null: false
  end

  create_table "pokemons", force: :cascade do |t|
    t.string "name"
    t.integer "level", default: 1
    t.integer "max_health_point"
    t.integer "current_health_point"
    t.integer "attack"
    t.integer "defence"
    t.integer "speed"
    t.integer "current_experience", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "pokedex_id", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.integer "power"
    t.integer "max_pp"
    t.string "element_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_skills_on_name", unique: true
  end

  create_table "trainers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_trainers_on_email", unique: true
  end

  add_foreign_key "pokemon_battle_logs", "pokemon_battles"
  add_foreign_key "pokemon_battle_logs", "pokemons", column: "attacker_id"
  add_foreign_key "pokemon_battle_logs", "pokemons", column: "defender_id"
  add_foreign_key "pokemon_battle_logs", "skills"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon1_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon2_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_loser_id"
  add_foreign_key "pokemon_battles", "pokemons", column: "pokemon_winner_id"
  add_foreign_key "pokemon_skills", "pokemons"
  add_foreign_key "pokemon_skills", "skills"
  add_foreign_key "pokemon_trainers", "pokemons"
  add_foreign_key "pokemon_trainers", "trainers"
  add_foreign_key "pokemons", "pokedexes"
end
