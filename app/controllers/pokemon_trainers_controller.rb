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
                # @used_pokemons = PokemonTrainer.all.map { |pokemon| pokemon.pokemon_id }
                # @pokemons = Pokemon.all.select{ |pokemon| !@used_pokemons.include?(pokemon.id)}
                # .map{|pokemon| [pokemon.name, pokemon.id]}
                # render 'trainers/show'
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
end
