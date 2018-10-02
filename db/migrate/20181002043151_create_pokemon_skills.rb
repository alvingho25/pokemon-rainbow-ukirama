class CreatePokemonSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemon_skills do |t|
      t.integer :current_pp

      t.timestamps
    end
    add_column :pokemon_skills, :pokemon_id, :integer, null: false
    add_foreign_key :pokemon_skills, :pokemons, column: :pokemon_id

    add_column :pokemon_skills, :skill_id, :integer, null: false
    add_foreign_key :pokemon_skills, :skills, column: :skill_id
  end
end