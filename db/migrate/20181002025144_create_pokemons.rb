class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.integer :level, default: 1
      t.integer :max_health_point
      t.integer :current_health_point
      t.integer :attack
      t.integer :defence
      t.integer :speed
      t.integer :current_experience, default: 0

      t.timestamps
    end
    add_column :pokemons, :pokedex_id, :integer, null: false
    add_foreign_key :pokemons, :pokedexes, column: :pokedex_id
  end
end
