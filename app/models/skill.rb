class Skill < ApplicationRecord
    has_many :pokemon_skills
    has_many :pokemon, through: :pokemon_skills
    has_many :logs, class_name: "PokemonBattleLog", foreign_key: "skill_id"

    element = ['normal', 'fire', 'fighting', 'water', 'flying', 'grass', 'poison', 'electric', 
        'ground', 'psychic', 'rock', 'ice', 'bug', 'dragon', 'ghost', 'dark', 'steel', 'fairy']
    validates :element_type, inclusion: { in: element,
    message: "%{value} is not a valid type" }
    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
    validates :power, numericality: { greater_than: 0}
    validates :max_pp, numericality: { greater_than: 0}
end
