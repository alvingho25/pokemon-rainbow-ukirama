class PokemonTrainersController < ApplicationController
    def create
        @trainer = Trainer.find(params[:trainer_id])
        if params[:pokemon_trainer].present?
            @pokemon_trainer = PokemonTrainer.new(
                trainer_id: @trainer.id,
                pokemon_id: params[:pokemon_trainer][:pokemon_id]
            )
            if @pokemon_trainer.save
                flash[:success] = "pokemon added to #{@trainer.name}"
                redirect_to trainer_path(@trainer)
            else
                redirect_to trainer_path(@trainer), :flash => { :danger => @pokemon_trainer.errors.full_messages.join(', ') }
            end
        else
            flash[:danger] = " Pokemon required"
            redirect_to trainer_path(@trainer)
        end
    end

    def destroy
        @trainer = Trainer.find(params[:trainer_id])
        @pokemon_trainer = @trainer.pokemon_trainers.find(params[:id])
        @pokemon_trainer.destroy
        flash[:success] = "Pokemon removed from #{@trainer.name}"
        redirect_to trainer_path(@trainer)
    end

    def healall
        @trainer = Trainer.find(params[:id])
        pokemons = @trainer.pokemons
        pokemons.each do |pokemon|
            pokemon_battle = pokemon.battles
            state = true
            pokemon_battle.each do |battle|
                if battle.state == 'On Going'
                    state = false
                    break
                end
            end
            if state == true
                pokemon.update!(current_health_point: pokemon.max_health_point)
                skills = pokemon.pokemon_skills
                skills.each do |skill|
                    skill.update!(current_pp: skill.skill.max_pp)
                end
            end
        end
        flash[:success] = "All #{@trainer.name} Pokemon currently not in battle has been healed"
        redirect_to trainer_path(@trainer)
    end

    def heal
        @trainer = Trainer.find(params[:id])
        pokemon = Pokemon.find(params[:pokemon_id])
        pokemon_battle = pokemon.battles
        state = true
        pokemon_battle.each do |battle|
            if battle.state == 'On Going'
                state = false
                break
            end
        end
        if state == true
            pokemon.update!(current_health_point: pokemon.max_health_point)
            skills = pokemon.pokemon_skills
            skills.each do |skill|
                skill.update!(current_pp: skill.skill.max_pp)
            end
            flash[:success] = "#{pokemon.name} has been healed"
        else
            flash[:danger] = "#{pokemon.name} can't be healed please make sure pokemon is not currently in battle"
        end
        redirect_to trainer_path(@trainer)
    end
end
