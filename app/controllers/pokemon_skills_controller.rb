class PokemonSkillsController < ApplicationController
    def create
        @pokemon = Pokemon.find(params[:pokemon_id])
        @skill = Skill.find(params[:skill][:skill_id])
        pokemon_skill = @pokemon.pokemon_skills.create(skill_id: params[:skill][:skill_id], current_pp: @skill.max_pp)
        if pokemon_skill.valid?
            flash[:success] = "Skill #{@skill.name} added to #{@pokemon.name}"
            redirect_to pokemon_path(@pokemon)
        else
            render 'pokemons/show'
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
