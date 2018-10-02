class PokemonSkillsController < ApplicationController
    def create
        @pokemon = Pokemon.find(params[:pokemon_id])
        @skill = Skill.find(params[:pokemon_skill][:skill_id])
        @pokemon_skill = PokemonSkill.new(pokemon_id: params[:pokemon_id],skill_id: params[:pokemon_skill][:skill_id], current_pp: @skill.max_pp)
        if @pokemon_skill.save
            flash[:success] = "Skill #{@skill.name} added to #{@pokemon.name}"
            redirect_to pokemon_path(@pokemon)
        else
            @skills = Skill.all.map { |skill| [skill.name, skill.id]}
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
