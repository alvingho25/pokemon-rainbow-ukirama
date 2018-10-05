class PokemonSkill < ApplicationRecord
    belongs_to :skill
    belongs_to :pokemon

    validate :same_skill, on: :create, if: :validate_present?
    validate :same_type, on: :create, if: :validate_present?
    validate :greater_than_max_pp
    validates :current_pp, numericality: {greater_than_or_equal_to: 0 }

    private
    def validate_present?
        if Pokemon.exists?(pokemon_id) && Skill.exists?(skill_id)
            return true
        else
            errors.add(:base, " No Pokemon or Skill Found")
        end
        false
    end

    def same_skill
        @pokemon = Pokemon.find(pokemon_id)
        @current_skill = @pokemon.pokemon_skills.map{ |s| s.skill_id }
        if @current_skill.include?(skill_id)
            errors.add(:base, " Pokemon can't have same skill")
        end
    end

    def same_type
        @pokemon = Pokemon.find(pokemon_id)
        @skill = Skill.find(skill_id)
        if @pokemon.pokedex.element_type != @skill.element_type
            errors.add(:base, " Pokemon can only have skill with same element type")
        end
    end

    def greater_than_max_pp
        if Skill.exists?(skill_id)
            @skill = Skill.find(skill_id)
            @max_pp = @skill.max_pp
            if current_pp > @max_pp
                errors.add(:current_pp, " can't be greater than #{@max_pp}")
            end
        else
            errors.add(:base, " Skill Required")
        end
    end
end
