class Pokemon < ApplicationRecord
    belongs_to :pokedex
    has_many :pokemon_skills, foreign_key: "pokemon_id", dependent: :destroy
    has_many :skill, through: :pokemon_skills

    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
end
