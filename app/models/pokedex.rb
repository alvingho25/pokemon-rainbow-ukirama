class Pokedex < ApplicationRecord
    element = ['Normal', 'Fire', 'Fighting', 'Water', 'Flying', 'Grass', 'Poison', 'Electric', 
                'Ground', 'Psychic', 'Rock', 'Ice', 'Bug', 'Dragon', 'Ghost', 'Dark', 'Steel', 'Fairy', '???']
    validates :element_type, inclusion: { in: element,
        message: "%{value} is not a valid type" }

    validates :name, length: { maximum: 45 }, presence: true
    # validates :image_url, length: { maximum: 45 }
end
