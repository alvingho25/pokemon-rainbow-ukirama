class Pokemon < ApplicationRecord
    belongs_to :pokedex
    has_many :pokemon_skills, foreign_key: "pokemon_id", dependent: :destroy
    has_many :skill, through: :pokemon_skills

    has_many :pokemon_battles, foreign_key: "pokemon1_id", dependent: :destroy
    has_many :pokemon_battles2, class_name: "PokemonBattle", foreign_key: "pokemon2_id", dependent: :destroy

    has_many :attacker, class_name: "PokemonBattleLog", foreign_key: "attacker_id"
    has_many :defender, class_name: "PokemonBattleLog", foreign_key: "defender_id"

    validates :name, length: { maximum: 45 }, presence: true, uniqueness: true
    validates :max_health_point, numericality: {greater_than: 0 }
    validates :current_health_point, numericality: { greater_than_or_equal_to: 0 }
    validates :current_health_point, numericality: { less_than_or_equal_to: :max_health_point },
                                     if: :max_health_point_present?
    validates :current_experience, numericality: {greater_than_or_equal_to: 0 }
    validates :attack, numericality: { greater_than: 0 }
    validates :defence, numericality: { greater_than: 0 }
    validates :speed, numericality: { greater_than: 0 }
    validates :level, numericality: { greater_than: 0 }
    
    def battles
        (pokemon_battles.all + pokemon_battles2.all).uniq
    end

    def wins
        sql = "select count(pokemon_battles.pokemon_winner_id) " +
        "from pokemons " +
        "join pokemon_battles on (pokemon_battles.pokemon_winner_id = pokemons.id) " +
        "where pokemons.id = #{id} " +
        "group by pokemon_battles.pokemon_winner_id"
        win = ActiveRecord::Base.connection.execute(sql)
        if win.values[0].nil?
            win = 0
        else
            win = win.values[0][0]
        end
        win
    end

    def loses
        sql = "select count(pokemon_battles.pokemon_winner_id) " +
        "from pokemons " +
        "join pokemon_battles on (pokemon_battles.pokemon_loser_id = pokemons.id) " +
        "where pokemons.id = #{id} " +
        "group by pokemon_battles.pokemon_loser_id"
        lose = ActiveRecord::Base.connection.execute(sql)
        if lose.values[0].nil?
            lose = 0
        else
            lose = lose.values[0][0]
        end
        lose
    end    

    private

    def max_health_point_present?
        max_health_point.present?
    end
    
end
