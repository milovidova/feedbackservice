class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.user = User.first 
    
    if @project.save
      redirect_to projects_path, notice: 'Проект создан!'
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :category, :feedback_request, :image)
  end
end