class Skill < ApplicationRecord
    has_many :pokemon_skills
    has_many :pokemon, through: :pokemon_skills

    element = ['Normal', 'Fire', 'Fighting', 'Water', 'Flying', 'Grass', 'Poison', 'Electric', 
        'Ground', 'Psychic', 'Rock', 'Ice', 'Bug', 'Dragon', 'Ghost', 'Dark', 'Steel', 'Fairy', '???']
    validates :element_type, inclusion: { in: element,
    message: "%{value} is not a valid type" }
    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
    validates :power, numericality: { greater_than: 0}
    validates :max_pp, numericality: { greater_than: 0}
end
