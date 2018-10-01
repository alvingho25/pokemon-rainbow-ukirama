class SkillsController < ApplicationController
    def index
        @skills = Skill.paginate(page: params[:page], :per_page => 5)
    end

    def new
        @skill = Skill.new
    end

    def create
        @skill = Skill.new(skill_params)
        if @skill.save
            flash[:success] = "Skill #{@skill.name} successfully created"
            redirect_to skill_path(@skill)
        else
            render :new
        end
    end

    def show
        @skill = Skill.find(params[:id])
    end

    def edit
        @skill = Skill.find(params[:id])
    end

    def update
        @skill = Skill.find(params[:id])
        if @skill.update_attributes(skill_params)
            flash[:success] = "Edit Succesfull"
            redirect_to skill_path(@skill)
        else
            render :edit
        end
    end

    def destroy
        skill = Skill.find(params[:id]).destroy
        flash[:success] = "Skill deleted"
        redirect_to skills_path
    end

    private
    def skill_params
        params.require(:skill).permit(:name, :power, :max_pp, :element_type)
    end
end
