class CreatePokemonTrainers < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_trainers do |t|
      t.integer :battle, default: 0
      t.integer :win, default: 0
      t.integer :lose, default: 0

      t.timestamps
    end
    add_column :pokemon_trainers, :trainer_id, :integer, null: false
    add_foreign_key :pokemon_trainers, :trainers, column: :trainer_id

    add_column :pokemon_trainers, :pokemon_id, :integer, null: false
    add_foreign_key :pokemon_trainers, :pokemons, column: :pokemon_id
  end
end
