class PokedexesController < ApplicationController
    add_breadcrumb "Home", :root_path
    add_breadcrumb "Pokedexes", :pokedexes_path

    def index
        @pokedexes = Pokedex.paginate(page: params[:page], :per_page => 15)
    end

    def new
        @pokedex = Pokedex.new
        add_breadcrumb "New", new_pokedex_path
    end

    def create
        @pokedex = Pokedex.new(pokedex_params)
        if @pokedex.save
            flash[:success] = "Pokedex #{@pokedex.name} successfully created"
            redirect_to pokedex_path(@pokedex)
        else
            render :new
        end
    end

    def show
        @pokedex = Pokedex.find(params[:id])
        add_breadcrumb "#{@pokedex.name}", pokedex_path(@pokedex)
    end

    def edit
        @pokedex = Pokedex.find(params[:id])
        add_breadcrumb "#{@pokedex.name}", pokedex_path(@pokedex)
        add_breadcrumb "Edit", edit_pokedex_path(@pokedex)
    end

    def update
        @pokedex = Pokedex.find(params[:id])
        if @pokedex.update_attributes(pokedex_params)
            flash[:success] = "Edit Succesfull"
            redirect_to pokedex_path(@pokedex)
        else
            render :edit
        end
    end

    def destroy
        pokedex = Pokedex.find(params[:id]).destroy
        flash[:success] = "Pokemon deleted"
        redirect_to pokedexes_path
    end

    private
    def pokedex_params
        params.require(:pokedex).permit(:name, :base_health_point, :base_attack, :base_defence, :base_speed, :element_type, :image_url)
    end
end
