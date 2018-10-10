class StaticPagesController < ApplicationController
    add_breadcrumb "Home", :root_path
    def home
        @element_type = ['normal', 'fire', 'fighting', 'water', 'flying', 'grass', 'poison', 'electric', 
            'ground', 'psychic', 'rock', 'ice', 'bug', 'dragon', 'ghost', 'dark', 'steel', 'fairy']
        @element = params[:element]
        if @element.nil?
            @element = 'normal'
        end
        @top_winner = PokemonBattleStatistic.top_5_winner(@element)
        @top_loser = PokemonBattleStatistic.top_5_loser(@element)
        @top_skill = PokemonBattleStatistic.top_5_skill(@element)
        @top_pokemon = PokemonBattleStatistic.top_5_used_pokemon(@element)
        @top_coward = PokemonBattleStatistic.top_5_surrender_pokemon(@element)
    end
end
