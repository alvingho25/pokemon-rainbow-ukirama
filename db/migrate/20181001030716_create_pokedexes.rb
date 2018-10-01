class CreatePokedexes < ActiveRecord::Migration[5.2]
  def change
    create_table :pokedexes do |t|
      t.string :name
      t.integer :base_health_point
      t.integer :base_attack
      t.integer :base_defence
      t.integer :base_speed
      t.string :element_type
      t.string :image_url

      t.timestamps
    end
    add_index :pokedexes, :name, unique: true
  end
end
