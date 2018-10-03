module PokemonBattleCalculator
    TABLE_RESISTANCE = {
        Normal: {
            Rock: 0.5,
            Ghost: 0,
            Steel: 0.5
        },
        Fight: {
            Normal: 2,
            Flying: 0.5,
            Poison: 0.5,
            Rock: 2,
            Bug: 0.5,
            Ghost: 0,
            Steel: 2,
            Pyschic: 0.5,
            Ice: 2,
            Dark: 2,
            Fairy: 0.5
        },
        Flying: {
            Fight: 2,
            Rock: 0.5,
            Bug: 2,
            Steel: 0.5,
            Grass: 2,
            Electric: 0.5,
        },
        Poison: {
            Posion: 0.5,
            Gound: 0.5,
            Rock: 0.5,
            Ghost: 0.5,
            Steel: 0,
            Grass: 2,
            Fairy: 2
        },
        Ground: {
            Flying: 0,
            Posion: 2,
            Rock: 2,
            Bug: 0.5,
            Steel: 2,
            Fire: 2,
            Grass: 0.5,
            Electric: 2
        },
        Rock: {
            Fight: 0.5,
            Flying: 2,
            Ground: 0.5,
            Bug: 2,
            Steel: 0.5,
            Fire: 2,
            Ice: 2
        },
        Bug: {
            Fight: 0.5,
            Flying: 0.5,
            Posion: 0.5,
            Ghost: 0.5,
            Steel: 0.5,
            Fire: 0.5,
            Grass: 2,
            Pyschic: 2,
            Dark: 2,
            Fairy: 0.5
        },
        Ghost: {
            Normal: 0,
            Ghost: 2,
            Pyschic: 2,
            Dark: 0.5
        },
        Steel: {
            Rock: 2,
            Steel: 0.5,
            Fire: 0.5,
            Water: 0.5,
            Electric: 0.5,
            Ice: 2,
            Fairy: 2
        },
        Fire: {
            Rock: 0.5,
            Bug: 2,
            Steel: 2,
            Fire: 0.5,
            Water: 0.5,
            Grass: 2,
            Ice: 2,
            Dragon: 0.5
        },
        Water: {
            Ground: 2,
            Rock: 2,
            Fire: 2,
            Water: 0.5,
            Grass: 0.5,
            Dragon: 0.5
        },
        Grass:{
            Flying: 0.5,
            Posion: 0.5,
            Ground: 2,
            Rock: 2,
            Bug: 0.5,
            Steel: 0.5,
            Fire:0.5,
            Water: 2,
            Grass: 0.5,
            Dragon: 0.5
        },
        Electric: {
            Flying: 2,
            Ground: 0,
            Water: 2,
            Grass: 0.5,
            Electric: 0.5,
            Dragon: 0.5
        },
        Pyschic: {
            Flying: 2,
            Ground: 2,
            Steel: 0.5,
            Pyschic: 0.5,
            Dark: 0
        },
        Ice: {
            Flying: 2,
            Ground: 2,
            Steel: 0.5,
            Fire: 0.5,
            Water: 0.5,
            Grass: 2,
            Ice: 0.5,
            Dragon: 2
        },
        Dragon: {
            Steel: 0.5,
            Dragon: 2,
            Fairy: 0
        },
        Dark: {
            Fight: 0.5,
            Ghost: 2,
            Pyschic: 2,
            Dark: 0.5,
            Fairy: 0.5
        },
        Fairy: {
            Fight: 2,
            Posion: 0.5,
            Steel: 0.5,
            Fire: 0.5,
            Dragon: 2,
            Dark: 2
        }
    }

    def self.calculate_damage(attacker, defender, skill_id)
        skill = Skill.find(skill_id)
        randomnumber = rand(85..100)
        if attacker.pokedex.element_type == skill.element_type
            stab = 1.5
        else
            stab = 1.0
        end
        resistance = TABLE_RESISTANCE[skill.element_type.to_sym][defender.pokedex.element_type.to_sym]
        if !resistance.present?
            resistance = 1
        end
        damage = ((((2 * attacker.level.to_f / 5 + 2) * attacker.attack * skill.power / defender.defence) / 50) + 2) * stab * resistance * (randomnumber.to_f / 100)
        damage.round
    end
end