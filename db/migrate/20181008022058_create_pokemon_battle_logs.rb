class CreatePokemonBattleLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_battle_logs do |t|
      t.integer :turn, mull: false
      t.integer :damage, default: 0
      t.integer :attacker_current_health_point, mull: false
      t.integer :defender_current_health_point, mull: false
      t.string :action_type, mull: false

      t.timestamps
    end
    add_column :pokemon_battle_logs, :pokemon_battle_id, :integer, null: false
    add_foreign_key :pokemon_battle_logs, :pokemon_battles, column: :pokemon_battle_id

    add_column :pokemon_battle_logs, :skill_id, :integer, null: true
    add_foreign_key :pokemon_battle_logs, :skills, column: :skill_id

    add_column :pokemon_battle_logs, :attacker_id, :integer, null: false
    add_foreign_key :pokemon_battle_logs, :pokemons, column: :attacker_id

    add_column :pokemon_battle_logs, :defender_id, :integer, null: false
    add_foreign_key :pokemon_battle_logs, :pokemons, column: :defender_id
  end
end
