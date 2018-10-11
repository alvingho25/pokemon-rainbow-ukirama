class CreateEvolutionLists < ActiveRecord::Migration[5.2]
  def change
    create_table :evolution_lists do |t|
      t.string :pokedex_from_name
      t.string :pokedex_to_name
      t.integer :level

      t.timestamps
    end
  end
end
