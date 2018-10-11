module PokemonBattleCalculator
    TABLE_RESISTANCE = {
        normal: {
            rock: 0.5,
            ghost: 0,
            steel: 0.5
        },
        fighting: {
            normal: 2,
            flying: 0.5,
            poison: 0.5,
            rock: 2,
            bug: 0.5,
            ghost: 0,
            steel: 2,
            psychic: 0.5,
            ice: 2,
            dark: 2,
            fairy: 0.5
        },
        flying: {
            fighting: 2,
            rock: 0.5,
            bug: 2,
            steel: 0.5,
            grass: 2,
            electric: 0.5,
        },
        poison: {
            poison: 0.5,
            ground: 0.5,
            rock: 0.5,
            ghost: 0.5,
            steel: 0,
            grass: 2,
            fairy: 2
        },
        ground: {
            flying: 0,
            poison: 2,
            rock: 2,
            bug: 0.5,
            steel: 2,
            fire: 2,
            grass: 0.5,
            electric: 2
        },
        rock: {
            fighting: 0.5,
            flying: 2,
            ground: 0.5,
            bug: 2,
            steel: 0.5,
            fire: 2,
            ice: 2
        },
        bug: {
            fighting: 0.5,
            flying: 0.5,
            poison: 0.5,
            ghost: 0.5,
            steel: 0.5,
            fire: 0.5,
            grass: 2,
            psychic: 2,
            dark: 2,
            fairy: 0.5
        },
        ghost: {
            normal: 0,
            ghost: 2,
            psychic: 2,
            dark: 0.5
        },
        steel: {
            rock: 2,
            steel: 0.5,
            fire: 0.5,
            water: 0.5,
            electric: 0.5,
            ice: 2,
            fairy: 2
        },
        fire: {
            rock: 0.5,
            bug: 2,
            steel: 2,
            fire: 0.5,
            water: 0.5,
            grass: 2,
            ice: 2,
            dragon: 0.5
        },
        water: {
            ground: 2,
            rock: 2,
            fire: 2,
            water: 0.5,
            grass: 0.5,
            dragon: 0.5
        },
        grass:{
            flying: 0.5,
            poison: 0.5,
            ground: 2,
            rock: 2,
            bug: 0.5,
            steel: 0.5,
            fire:0.5,
            water: 2,
            grass: 0.5,
            dragon: 0.5
        },
        electric: {
            flying: 2,
            ground: 0,
            water: 2,
            grass: 0.5,
            electric: 0.5,
            dragon: 0.5
        },
        psychic: {
            flying: 2,
            ground: 2,
            steel: 0.5,
            psychic: 0.5,
            dark: 0
        },
        ice: {
            flying: 2,
            ground: 2,
            steel: 0.5,
            fire: 0.5,
            water: 0.5,
            grass: 2,
            ice: 0.5,
            dragon: 2
        },
        dragon: {
            steel: 0.5,
            dragon: 2,
            fairy: 0
        },
        dark: {
            fighting: 0.5,
            ghost: 2,
            psychic: 2,
            dark: 0.5,
            fairy: 0.5
        },
        fairy: {
            fighting: 2,
            poison: 0.5,
            steel: 0.5,
            fire: 0.5,
            dragon: 2,
            dark: 2
        }
    }

    Stats = Struct.new(:health, :attack, :defence, :speed)

    def self.calculate_damage(attacker, defender, skill_id)
        skill = Skill.find(skill_id)
        randomnumber = rand(85..100)
        if attacker.pokedex.element_type == skill.element_type
            stab = 1.5
        else
            stab = 1.0
        end
        if TABLE_RESISTANCE[skill.element_type.to_sym][defender.pokedex.element_type.to_sym].present?
            resistance = TABLE_RESISTANCE[skill.element_type.to_sym][defender.pokedex.element_type.to_sym]
        else
            resistance = 1
        end
        damage = ((((2 * attacker.level.to_f / 5 + 2) * attacker.attack * skill.power / defender.defence) / 50) + 2) * stab * resistance * (randomnumber.to_f / 100)
        damage.round
    end

    def self.calculate_experience(loser)
        randomnumber = rand(20..150)
        exp = randomnumber * loser.level
        exp
    end

    def self.level_up?(level, experience)
        max_experience = (2**level)*100
        if experience >= max_experience
            return true
        end
        false
    end

    def self.calculate_level_up_extra_stats
        stats = Stats.new(rand(10..20), rand(1..5), rand(1..5), rand(1..5))
        stats
    end

    def self.calculate_evolve_extra_stats(pokedex_before_evolve_id, pokedex_after_evolve_id)
        pokedex_before_evolve = Pokedex.find(pokedex_before_evolve_id)
        pokedex_after_evolve = Pokedex.find(pokedex_after_evolve_id)
        health = pokedex_after_evolve.base_health_point - pokedex_before_evolve.base_health_point
        attack = pokedex_after_evolve.base_attack - pokedex_before_evolve.base_attack
        defence = pokedex_after_evolve.base_defence - pokedex_before_evolve.base_defence
        speed = pokedex_after_evolve.base_speed - pokedex_before_evolve.base_speed
        stats = Stats.new(health, attack, defence, speed)
        stats
    end
end