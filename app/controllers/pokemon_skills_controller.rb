class PokemonSkillsController < ApplicationController
    def create
        @pokemon = Pokemon.find(params[:pokemon_id])
        if params[:pokemon_skill][:skill_id].present?
            @skill = Skill.find(params[:pokemon_skill][:skill_id])
            @pokemon_skill = PokemonSkill.new(pokemon_id: params[:pokemon_id],skill_id: params[:pokemon_skill][:skill_id], current_pp: @skill.max_pp)
            if @pokemon_skill.save
                flash[:success] = "Skill #{@skill.name} added to #{@pokemon.name}"
                redirect_to pokemon_path(@pokemon)
            else
                flash[:danger] = " New skill failed"
                redirect_to pokemon_path(@pokemon)
            end
        else
            flash[:danger] = " Skill required"
            redirect_to pokemon_path(@pokemon)
        end
    end

    def destroy
        @pokemon = Pokemon.find(params[:pokemon_id])
        @pokemon_skill = @pokemon.pokemon_skills.find(params[:id])
        @pokemon_skill.destroy
        flash[:success] = "Skill removed from #{@pokemon.name}"
        redirect_to pokemon_path(@pokemon)
    end
end
