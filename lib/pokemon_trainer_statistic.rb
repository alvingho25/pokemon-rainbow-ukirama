module PokemonTrainerStatistic
    def self.top_winner(trainer_id)
        sql = "
            select 
                pokemons.name, 
                pokemon_trainers.win
            from 
                pokemon_trainers
            join trainers 
                on trainers.id = pokemon_trainers.trainer_id
            join pokemons 
                on pokemons.id = pokemon_trainers.pokemon_id
            where 
                trainers.id = #{trainer_id}
            order by 
                pokemon_trainers.win desc"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_winner = pokemons.values
    end

    def self.top_loser(trainer_id)
        sql = "
            select 
                pokemons.name, 
                pokemon_trainers.lose
            from 
                pokemon_trainers
            join trainers 
                on trainers.id = pokemon_trainers.trainer_id
            join pokemons 
                on pokemons.id = pokemon_trainers.pokemon_id
            where 
                trainers.id =  #{trainer_id}
            order by 
                pokemon_trainers.lose desc"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_loser = pokemons.values
    end

    def self.top_battle(trainer_id)
        sql = "
            select 
                pokemons.name, 
                pokemon_trainers.battle
            from 
                pokemon_trainers
            join trainers 
                on trainers.id = pokemon_trainers.trainer_id
            join pokemons 
                on pokemons.id = pokemon_trainers.pokemon_id
            where 
                trainers.id =  #{trainer_id}
            order by 
                pokemon_trainers.battle desc"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_battle = pokemons.values
    end

    def self.win_rate(trainer_id)
        sql = "
            select 
                pokemons.name, 
                case
                    when pokemon_trainers.battle > 0 then pokemon_trainers.win*100/pokemon_trainers.battle
                    else 0
                end as \"Win Rate\"
            from 
                pokemon_trainers
            join trainers 
                on trainers.id = pokemon_trainers.trainer_id
            join pokemons 
                on pokemons.id = pokemon_trainers.pokemon_id
            where 
                trainers.id = #{trainer_id}
            order by 2 desc;"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_battle = pokemons.values
    end

    def self.element_rate(trainer_id)
        sql = "
            select 
                pokedexes.element_type, 
                count(pokemon_trainers.pokemon_id)*100/5 as \"element rate\"
            from 
                pokemon_trainers
            join trainers 
                on trainers.id = pokemon_trainers.trainer_id
            join pokemons 
                on pokemons.id = pokemon_trainers.pokemon_id
            join pokedexes 
                on pokedexes.id = pokemons.pokedex_id
            where 
                trainers.id = #{trainer_id}
            group by 
                pokedexes.element_type
            order by 2 desc"
        pokemons = ActiveRecord::Base.connection.execute(sql)
        top_battle = pokemons.values
    end
end