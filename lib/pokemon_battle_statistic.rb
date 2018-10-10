module PokemonBattleStatistic
    def self.top_5_winner(element)
        sql = "
            select
                pokemons.name as name,
                count(pokemon_battles.pokemon_winner_id) as count
            from pokemons
            join pokedexes
                on (pokedexes.id = pokemons.pokedex_id)
            join pokemon_battles
                on (pokemon_battles.pokemon_winner_id = pokemons.id)
            where
                pokedexes.element_type = '#{element}'
            group by
                pokemon_battles.pokemon_winner_id,
                pokemons.name
            order by
                count(pokemon_battles.pokemon_winner_id) desc
            limit 5;"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_winner = pokemons.values
    end

    def self.top_5_loser(element)
        sql = "
            select 
                pokemons.name as name, 
                count(pokemon_battles.pokemon_loser_id)as count 
            from 
                pokemons 
            join pokedexes 
                on (pokedexes.id = pokemons.pokedex_id) 
            join pokemon_battles 
                on (pokemon_battles.pokemon_loser_id = pokemons.id) 
            where 
                pokedexes.element_type = '#{element}' 
            group by 
                pokemon_battles.pokemon_loser_id, pokemons.name 
            order by 
                count(pokemon_battles.pokemon_loser_id) desc 
            limit 5;"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_loser = pokemons.values
    end

    def self.top_5_skill(element)
        sql = "
            select 
                skills.name, 
                count(pokemon_battle_logs.skill_id) 
            from 
                skills
            join pokemon_battle_logs 
                on (skills.id = pokemon_battle_logs.skill_id)
            where 
                skills.element_type = '#{element}'
            group by 
                pokemon_battle_logs.skill_id, skills.name
            order by 
                count(pokemon_battle_logs.skill_id) desc
            limit 5;"
        skills = ActiveRecord::Base.connection.execute(sql)
        top_skill = skills.values
    end

    def self.top_5_used_pokemon(element)
        sql = "
            select 
                pokemons.name, 
                count(pokemons.name) from pokemons 
            join pokedexes 
                on (pokedexes.id = pokemons.pokedex_id)
            join pokemon_battles 
                on (pokemons.id in (pokemon_battles.pokemon1_id, pokemon_battles.pokemon2_id))
            where 
                pokedexes.element_type = '#{element}'
            group by 
                pokemons.name
            order by 
                count desc
            limit 5;"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_pokemons = pokemons.values
    end

    def self.top_5_surrender_pokemon(element)
        sql = "
            select 
                pokemons.name, 
                count(pokemons.name) 
            from pokemons 
            join pokedexes 
                on (pokedexes.id = pokemons.pokedex_id) 
            join pokemon_battle_logs 
                on (pokemons.id = pokemon_battle_logs.attacker_id)
            where 
                pokedexes.element_type = '#{element}' 
                and 
                pokemon_battle_logs.action_type = 'Surrender' 
            group by 
                pokemons.name
            order by 
                count desc 
            limit 5;"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_surrender = pokemons.values
    end
end