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
        @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
    end

    def destroy
        @pokemon_battle = PokemonBattle.find(params[:id]).destroy
        flash[:success] = "Battle Deleted"
        redirect_to pokemon_battles_path
    end

    def update
        require 'pry'
        @pokemon_battle = PokemonBattle.find(params[:id])
        current_turn = @pokemon_battle.current_turn
        if current_turn % 2 != 0
            @attacker = @pokemon_battle.pokemon1
            @defender = @pokemon_battle.pokemon2
        else
            @attacker = @pokemon_battle.pokemon2
            @defender = @pokemon_battle.pokemon1
        end
        if params[:commit] == 'Attack'
            @pokemon_skill = @attacker.pokemon_skills.find_by(skill_id: params[:attack][:skill_id])
            if @pokemon_skill.current_pp == 0
                flash.now[:danger] = "Skill PP Depleted Please choose another skill"
                @skill1 = @pokemon_battle.pokemon1.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                @skill2 = @pokemon_battle.pokemon2.pokemon_skills.map{ |s| [s.skill.name, s.skill_id]}
                render 'show'
            else
                damage = PokemonBattleCalculator.calculate_damage(@attacker, @defender, @pokemon_skill.skill_id)
                @defender.current_health_point = @defender.current_health_point - damage
                if @defender.current_health_point <= 0
                    @defender.current_health_point = 0
                    @pokemon_battle.pokemon_winner_id = @attacker.id
                    @pokemon_battle.pokemon_loser_id = @defender.id
                end
                @defender.save
                
                @pokemon_battle.current_turn = @pokemon_battle.current_turn + 1
                @pokemon_battle.save!

                @pokemon_skill.current_pp = @pokemon_skill.current_pp - 1
                @pokemon_skill.save!
                # binding.pry
                redirect_to pokemon_battle_path(@pokemon_battle)
            end
        else
            @pokemon_battle.pokemon_winner_id = @defender.id
            @pokemon_battle.pokemon_loser_id = @attacker.id
            @pokemon_battle.save!
            redirect_to pokemon_battle_path(@pokemon_battle)
        end
        
    end

    private 
    def battle_params
        params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
    end
end
