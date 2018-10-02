class Pokedex < ApplicationRecord
    has_many :pokemons
    element = ['Normal', 'Fire', 'Fighting', 'Water', 'Flying', 'Grass', 'Poison', 'Electric', 
                'Ground', 'Psychic', 'Rock', 'Ice', 'Bug', 'Dragon', 'Ghost', 'Dark', 'Steel', 'Fairy']
    validates :element_type, inclusion: { in: element,
        message: "%{value} is not a valid type" }
    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
    validates :base_health_point, numericality: { greater_than: 0}
    validates :base_attack, numericality: { greater_than: 0}
    validates :base_defence, numericality: { greater_than: 0}
    validates :base_speed, numericality: { greater_than: 0}
end