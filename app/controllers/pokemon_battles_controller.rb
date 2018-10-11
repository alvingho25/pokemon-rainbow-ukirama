class PokemonBattlesController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Pokemon Battles", :pokemon_battles_path

    def index
        @pokemon_battles = PokemonBattle.paginate(page: params[:page], :per_page => 15)
    end

    def new
        @pokemon_battle = PokemonBattle.new
        @pokemons = Pokemon.all.order(created_at: :asc).map{ |pokemon| [pokemon.name, pokemon.id] }
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
                pokemon1_level = @pokemon_battle.pokemon1.level
                pokemon2_level = @pokemon_battle.pokemon2.level
                AiEngine.auto_battle(@pokemon_battle.id)
                if PokemonEvolution.evolve?(@pokemon_battle.id, pokemon1_level, pokemon2_level)
                    redirect_to evolve_confirmation_pokemon_battle_path(@pokemon_battle) and return
                end
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
        @pokemon_battle = PokemonBattle.find(params[:id])
        pokemon1_level = @pokemon_battle.pokemon1.level
        pokemon2_level = @pokemon_battle.pokemon2.level
        if params[:commit] == "Auto"
            AiEngine.auto_battle(@pokemon_battle.id)
            if PokemonEvolution.evolve?(@pokemon_battle.id, pokemon1_level, pokemon2_level)
                redirect_to evolve_confirmation_pokemon_battle_path(@pokemon_battle)
            else
                redirect_to pokemon_battle_path(@pokemon_battle)
            end
        else
            battle_engine = BattleEngine.new(battle_id: params[:id].to_i,pokemon_id: params[:attack][:pokemon_id].to_i, skill_id: params[:attack][:skill_id].to_i, action: params[:commit])
            if battle_engine.valid_next_turn?
                if battle_engine.next_turn!
                    battle_engine.save!
                    @pokemon_battle.reload
                    if @pokemon_battle.battle_type == 'vs AI' && @pokemon_battle.state == 'On Going'
                        AiEngine.ai_turn(@pokemon_battle.id)
                    end
                    if PokemonEvolution.evolve?(@pokemon_battle.id, pokemon1_level, pokemon2_level)
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
                    stats = PokemonEvolution.calculate_evolve_extra_stats(@pokemon.pokedex_id, @pokemon_evolve_to.id)
                    @pokemon.pokedex_id = @pokemon_evolve_to.id
                    @pokemon.max_health_point = @pokemon.max_health_point + stats.health
                    @pokemon.attack = @pokemon.attack + stats.attack
                    @pokemon.defence = @pokemon.defence + stats.defence
                    @pokemon.speed = @pokemon.speed + stats.speed
                    @pokemon.save!
                    redirect_to skill_change_pokemon_battle_path(@pokemon_battle)
                end
            else
                redirect_to pokemon_battle_path(@pokemon_battle)
            end
        else
            redirect_to pokemon_battle_path(@pokemon_battle)
        end
    end

    def skill_change
        @pokemon_battle = PokemonBattle.find(params[:id])
        @pokemon_skill = PokemonSkill.new
        @pokemon = Pokemon.find(@pokemon_battle.pokemon_winner_id)
        @current_skill = @pokemon.pokemon_skills.map{ |s| s.skill_id }
        @pokemon_skills = @pokemon.pokemon_skills.map{ |s| [s.skill.name, s.skill.id]}
        @skills = Skill.all.select{ |s| !@current_skill.include?(s.id) && s.element_type == @pokemon.pokedex.element_type }
        .map{|s| [s.name, s.id]}
    end

    def change_skill
        @pokemon_battle = PokemonBattle.find(params[:id])
        @pokemon = Pokemon.find(@pokemon_battle.pokemon_winner_id)
        if params[:change_skill][:skill_delete_id].present?
            @pokemon_skill = @pokemon.pokemon_skills.find_by(skill_id: params[:change_skill][:skill_delete_id])
            @pokemon_skill.destroy
            flash[:success] = "Skill removed from #{@pokemon.name}"
        end
        if params[:change_skill][:skill_add_id].present?
            @skill = Skill.find(params[:change_skill][:skill_add_id])
            @pokemon_skill = PokemonSkill.new(pokemon_id: @pokemon.id,skill_id: @skill.id, current_pp: @skill.max_pp)
            if @pokemon_skill.save
                flash[:success] = "Skill #{@skill.name} added to #{@pokemon.name}"
                redirect_to pokemon_battle_path(@pokemon_battle)
            else
                @current_skill = @pokemon.pokemon_skills.map{ |s| s.skill_id }
                @pokemon_skills = @pokemon.pokemon_skills.map{ |s| [s.skill.name, s.skill.id]}
                @skills = Skill.all.select{ |s| !@current_skill.include?(s.id) && s.element_type == @pokemon.pokedex.element_type }
                    .map{|s| [s.name, s.id]}
                render :skill_change
            end
        else
            flash[:success] = "No Skill added"
            redirect_to pokemon_battle_path(@pokemon_battle)
        end
    end

    private 
    def battle_params
        params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
    end
end
