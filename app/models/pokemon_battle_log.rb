class PokemonBattleLog < ApplicationRecord
    belongs_to :battle, class_name: "PokemonBattle", foreign_key: "pokemon_battle_id"
    belongs_to :skill, optional: true
    belongs_to :attacker, class_name: "Pokemon", foreign_key: "attacker_id"
    belongs_to :defender, class_name: "Pokemon", foreign_key: "defender_id"

    validates :turn, presence: true, numericality: {greater_than: 0 }
    validates :damage, numericality: {greater_than_or_equal_to: 0 }
    validates :attacker_current_health_point, presence: true
    validates :defender_current_health_point, presence: true
    validates :action_type, inclusion: { in: ['Attack', 'Surrender'],
        message: "%{value} is not a valid action" }
end
