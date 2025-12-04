# class ProjectsController < ApplicationController
#   def index
#     @projects = Project.all
#   end

#   def new
#     @project = Project.new
#   end

#   def create
#     @project = Project.new(project_params)
#     @project.user = User.first 
    
#     if @project.save
#       redirect_to projects_path, notice: 'Проект создан!'
#     else
#       render :new
#     end
#   end

#   private

#   def project_params
#     params.require(:project).permit(:title, :description, :category, :feedback_request, :image)
#   end
# end



class ProjectsController < ApplicationController

  def index
    @projects = Project.all
    @view_mode = :gallery  
  end


  def grid
    @projects = Project.includes(:user).all
    @view_mode = :grid
    render :index 
  end


  def show
    @project = Project.includes(feedbacks: :user).find(params[:id])
  end


  def new
    @project = Project.new
  end


  def create
    @project = Project.new(project_params)
    @project.user = User.first 
    
    if @project.save
      redirect_to project_path(@project), notice: 'Проект создан!'
    else
      render :new
    end
  end

 
  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    
    redirect_to projects_path, notice: 'Проект успешно удален'
  end

 
  def edit
    @project = Project.find(params[:id])
  end


  def update
    @project = Project.find(params[:id])
    
    if @project.update(project_params)
      redirect_to project_path(@project), notice: 'Проект обновлен!'
    else
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :category, :feedback_request, :image)
  end
end