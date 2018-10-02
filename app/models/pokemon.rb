class Pokemon < ApplicationRecord
    belongs_to :pokedex
    has_many :pokemon_skills, foreign_key: "pokemon_id", dependent: :destroy
    has_many :skill, through: :pokemon_skills

    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
    validates :current_hit_point, numericality: { less_than_or_equal_to: :max_hit_point, greater_than_or_equal_to: 0 }
    validates :experience, numericality: {greater_than_or_equal_to: 0 }
    validates :max_health_point, numericality: {greater_than: 0 }
    validates :attack, numericality: {greater_than: 0 }
    validates :defence, numericality: {greater_than: 0 }
    validates :speed, numericality: {greater_than: 0 }
    validates :level, numericality: {greater_than: 0 }
    
end
