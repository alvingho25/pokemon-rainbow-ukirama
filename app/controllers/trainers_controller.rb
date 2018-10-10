class TrainersController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Trainers", :trainers_path

    def index
        @trainers = Trainer.paginate(page: params[:page], :per_page => 15)
    end

    def new
        @trainer = Trainer.new
        add_breadcrumb "New", new_trainer_path
    end

    def create
        @trainer = Trainer.new(trainer_params)
        if @trainer.save
            flash[:success] = "#{@trainer.name} successfully created"
            redirect_to trainer_path(@trainer)
        else
            render :new
        end
    end

    def show
        @name = params[:name]
        if @name.nil?
            @name = 'pokemon'
        end
        @trainer = Trainer.find(params[:id])
        if @name == 'pokemon'
            @pokemon_trainer = PokemonTrainer.new
            @used_pokemons = PokemonTrainer.all.map { |pokemon| pokemon.pokemon_id }
            @pokemons = Pokemon.all.select{ |pokemon| !@used_pokemons.include?(pokemon.id)}
            .map{|pokemon| [pokemon.name, pokemon.id]}
        else
            @top_winner = PokemonTrainerStatistic.top_winner(params[:id])
            @top_loser = PokemonTrainerStatistic.top_loser(params[:id])
            @top_battle = PokemonTrainerStatistic.top_battle(params[:id])
            @win_rate = PokemonTrainerStatistic.win_rate(params[:id])
            @element_rate = PokemonTrainerStatistic.element_rate(params[:id])
        end
        add_breadcrumb "#{@trainer.name}", trainer_path(@trainer)
    end

    def edit
        @trainer = Trainer.find(params[:id])
        add_breadcrumb "#{@trainer.name}", trainer_path(@trainer)
        add_breadcrumb "Edit", edit_trainer_path(@trainer)
    end

    def update
        @trainer = Trainer.find(params[:id])
        if @trainer.update_attributes(update_params)
            flash[:success] = "Update Succesfull"
            redirect_to trainer_path(@trainer)
        else
            render :edit
        end
    end

    def destroy
        trainer = Trainer.find(params[:id]).destroy
        flash[:success] = "Trainer deleted"
        redirect_to trainers_path
    end

    private
    def trainer_params
        params.require(:trainer).permit(:name, :email, :password)
    end

    def update_params
        params.require(:trainer).permit(:name, :email)
    end
end
