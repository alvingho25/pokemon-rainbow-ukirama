class CreatePokemonBattles < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_battles do |t|
      t.integer :current_turn, default: 1
      t.string :state, default: "On Going"
      t.integer :experience_gain
      t.integer :pokemon1_max_health_point
      t.integer :pokemon2_max_health_point
      t.string :battle_type

      t.timestamps
    end
    add_column :pokemon_battles, :pokemon1_id, :integer, null: false
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon1_id

    add_column :pokemon_battles, :pokemon2_id, :integer, null: false
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon2_id

    add_column :pokemon_battles, :pokemon_winner_id, :integer, null: true
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon_winner_id

    add_column :pokemon_battles, :pokemon_loser_id, :integer, null: true
    add_foreign_key :pokemon_battles, :pokemons, column: :pokemon_loser_id
  end
end
