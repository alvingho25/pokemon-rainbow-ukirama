class PokemonsController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Pokemons", :pokemons_path

    def index
        @pokemons = Pokemon.paginate(page: params[:page], :per_page => 15).order(created_at: :asc)
    end

    def new
        @pokemon = Pokemon.new
        @pokedexes = Pokedex.all.map { |pokedex| [pokedex.name, pokedex.id]}
        add_breadcrumb "New", new_pokemon_path
    end

    def create
        params = pokemon_params
        pokedex = Pokedex.find(params['pokedex_id'])
        @pokemon = Pokemon.new(params)
        @pokemon.max_health_point = pokedex.base_health_point
        @pokemon.current_health_point = pokedex.base_health_point
        @pokemon.attack = pokedex.base_attack
        @pokemon.defence = pokedex.base_defence
        @pokemon.speed = pokedex.base_speed
        if @pokemon.save
            flash[:success] = "Pokemon #{@pokemon.name} successfully created"
            redirect_to pokemon_path(@pokemon)
        else
            @pokedexes = Pokedex.all.map { |pokedex| [pokedex.name, pokedex.id]}
            render :new
        end
    end

    def show
        @pokemon = Pokemon.find(params[:id])
        @current_skill = @pokemon.pokemon_skills.map{ |s| s.skill_id }
        @skills = Skill.all.select{ |s| !@current_skill.include?(s.id) && s.element_type == @pokemon.pokedex.element_type }
        .map{|s| [s.name, s.id]}
        # @skills = Skill.all.map { |skill| [skill.name, skill.id]}
        @pokemon_skill = PokemonSkill.new
        add_breadcrumb "#{@pokemon.name}", pokemon_path(@pokemon)
    end 

    def edit
        @pokemon = Pokemon.find(params[:id])
        add_breadcrumb "#{@pokemon.name}", pokemon_path(@pokemon)
        add_breadcrumb "Edit", edit_pokemon_path(@pokemon)
    end

    def update
        @pokemon = Pokemon.find(params[:id])
        if @pokemon.update_attributes(edit_params)
            flash[:success] = "Update Succesfull"
            redirect_to pokemon_path(@pokemon)
        else
            render :edit
        end
    end

    def destroy
        pokemon = Pokemon.find(params[:id]).destroy
        flash[:success] = "Pokemon deleted"
        redirect_to pokemons_path
    end

    def healall
        pokemons = Pokemon.all
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
        flash[:success] = "All Pokemon currently not in battle has been healed"
        redirect_to pokemons_path
    end

    def heal
        pokemon = Pokemon.find(params[:id])
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
        redirect_to pokemons_path
    end

    private
    def pokemon_params
        params.require(:pokemon).permit(:name, :pokedex_id)
    end

    def edit_params
        params.require(:pokemon).permit(:name, :attack, :defence, :speed, :current_health_point, :max_health_point, :current_experience)
    end
end
