class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :power
      t.integer :max_pp
      t.string :element_type

      t.timestamps
    end
    add_index :skills, :name, unique: true
  end
end
