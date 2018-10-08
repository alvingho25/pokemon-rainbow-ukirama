class PokemonBattlesController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Pokemon Battles", :pokemon_battles_path

    def index
        @pokemon_battles = PokemonBattle.paginate(page: params[:page], :per_page => 15)
    end

    def new
        @pokemon_battle = PokemonBattle.new
        @pokemons = Pokemon.all.map{ |pokemon| [pokemon.name, pokemon.id] }
        add_breadcrumb "New", new_pokemon_battle_path
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
        @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
        @logs = @pokemon_battle.logs
        add_breadcrumb "#{@pokemon_battle.pokemon1.name} vs #{@pokemon_battle.pokemon2.name}", pokemon_battle_path(@pokemon_battle)
    end

    def destroy
        @pokemon_battle = PokemonBattle.find(params[:id]).destroy
        flash[:success] = "Battle Deleted"
        redirect_to pokemon_battles_path
    end

    def update
        @pokemon_battle = PokemonBattle.find(params[:id])
        battle_engine = BattleEngine.new(battle_id: params[:id].to_i,pokemon_id: params[:attack][:pokemon_id].to_i, skill_id: params[:attack][:skill_id].to_i, action: params[:commit])
        if battle_engine.valid_next_turn?
            if battle_engine.next_turn!
                battle_engine.save!
                redirect_to pokemon_battle_path(@pokemon_battle)
            else
                flash.now[:danger] = "Skill Not Found or Skill PP is depleted"
                @skill1 = @pokemon_battle.pokemon1.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                render 'show'
            end
        else
            flash.now[:danger] = "Move not valid"
            @skill1 = @pokemon_battle.pokemon1.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
            @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
            render 'show'
        end
    end

    private 
    def battle_params
        params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
    end
end
