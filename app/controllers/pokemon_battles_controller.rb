class PokemonBattlesController < ApplicationController
    include PokemonBattleCalculator
    def index
        @pokemon_battles = PokemonBattle.paginate(page: params[:page], :per_page => 5)
    end

    def new
        @pokemon_battle = PokemonBattle.new
        @pokemons = Pokemon.all.map{ |pokemon| [pokemon.name, pokemon.id] }
    end

    def create
        @pokemon1 = Pokemon.find(battle_params[:pokemon1_id])
        @pokemon2 = Pokemon.find(battle_params[:pokemon2_id])
        @pokemon_battle = PokemonBattle.new(battle_params)
        @pokemon_battle.pokemon1_max_health_point = @pokemon1.max_health_point
        @pokemon_battle.pokemon2_max_health_point = @pokemon2.max_health_point
        if @pokemon_battle.save
            flash[:success] = "Battle successfully created, Lets Fight!!"
            redirect_to pokemon_battle_path(@pokemon_battle)
        else
            @pokemons = Pokemon.all.map{ |pokemon| [pokemon.name, pokemon.id] }
            render 'new'
        end
    end

    def show
        @pokemon_battle = PokemonBattle.find(params[:id])
        @skill1 = @pokemon_battle.pokemon1.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
    end

    def destroy
        @pokemon_battle = PokemonBattle.find(params[:id]).destroy
        flash[:success] = "Battle Deleted"
        redirect_to pokemon_battles_path
    end

    private 
    def battle_params
        params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
    end
end
