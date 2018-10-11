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
        @pokemon_battle.battle_type = params[:commit]
        if @pokemon_battle.save
            flash[:success] = "Battle successfully created, Lets Fight!!"
            if params[:commit] == 'Auto'
                AiEngine.auto_battle(@pokemon_battle.id)
            end
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
        if params[:commit] == "Auto"
            AiEngine.auto_battle(params[:id])
            redirect_to pokemon_battle_path(params[:id])
        else
            @pokemon_battle = PokemonBattle.find(params[:id])
            battle_engine = BattleEngine.new(battle_id: params[:id].to_i,pokemon_id: params[:attack][:pokemon_id].to_i, skill_id: params[:attack][:skill_id].to_i, action: params[:commit])
            if battle_engine.valid_next_turn?
                if battle_engine.next_turn!
                    battle_engine.save!
                    @pokemon_battle.reload
                    if @pokemon_battle.battle_type == 'vs AI' && @pokemon_battle.state == 'On Going'
                        AiEngine.my_turn(@pokemon_battle.id)
                    end
                    if battle_engine.evolve?
                        redirect_to evolve_confirmation_pokemon_battle_path(@pokemon_battle)
                    else
                        redirect_to pokemon_battle_path(@pokemon_battle)
                    end
                else
                    flash.now[:danger] = "Skill Not Found or Skill PP is depleted"
                    @skill1 = @pokemon_battle.pokemon1.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                    @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                    @logs = @pokemon_battle.logs
                    render 'show'
                end
            else
                flash.now[:danger] = "Move not valid"
                @skill1 = @pokemon_battle.pokemon1.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                @logs = @pokemon_battle.logs
                render 'show'
            end
        end
    end

    def evolve_confirmation
        @pokemon_battle = PokemonBattle.find(params[:id])
        if !@pokemon_battle.pokemon_winner_id.nil?
            @pokemon = Pokemon.find(@pokemon_battle.pokemon_winner_id)
            if EvolutionList.exists?(pokedex_from_name: @pokemon.pokedex.name)
                @evolve_to = EvolutionList.find_by(pokedex_from_name: @pokemon.pokedex.name)
                @pokemon_evolve_to = Pokedex.find_by(name: @evolve_to.pokedex_to_name)
            end
        else
            redirect_to pokemon_battle_path(@pokemon_battle)
        end
    end

    def evolve
        @pokemon_battle = PokemonBattle.find(params[:id])
        if params[:commit] == 'Yes'
            if !@pokemon_battle.pokemon_winner_id.nil?
                @pokemon = Pokemon.find(@pokemon_battle.pokemon_winner_id)
                if EvolutionList.exists?(pokedex_from_name: @pokemon.pokedex.name)
                    @evolve_to = EvolutionList.find_by(pokedex_from_name: @pokemon.pokedex.name)
                    @pokemon_evolve_to = Pokedex.find_by(name: @evolve_to.pokedex_to_name)
                    stats = PokemonBattleCalculator.calculate_evolve_extra_stats(@pokemon.pokedex_id, @pokemon_evolve_to.id)
                    @pokemon.pokedex_id = @pokemon_evolve_to.id
                    @pokemon.max_health_point = @pokemon.max_health_point + stats.health
                    @pokemon.attack = @pokemon.attack + stats.attack
                    @pokemon.defence = @pokemon.defence + stats.defence
                    @pokemon.speed = @pokemon.speed + stats.speed
                    @pokemon.save!
                    redirect_to pokemon_battle_path(@pokemon_battle)
                end
            else
                redirect_to pokemon_battle_path(@pokemon_battle)
            end
        else
            redirect_to pokemon_battle_path(@pokemon_battle)
        end
    end

    private 
    def battle_params
        params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
    end
end
