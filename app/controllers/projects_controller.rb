class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :grid, :show]

  def index
    @projects = Project.all
    @view_mode = :gallery

    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end

  def grid
    @projects = Project.includes(:user).all
    @view_mode = :grid
    render :index
  end

  def show
    @project = Project.includes(feedbacks: :user).find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  def new
  
    @project  = current_user.projects.new
    @projects = current_user.projects

     @my_feedbacks = current_user.feedbacks.includes(:project)
  end

  def create
    @project = current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to project_path(@project), notice: "Проект создан!" }
        format.json { render :show, status: :created, location: @project }
      else
 
        @projects = current_user.projects
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, notice: "Проект успешно удален"
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Проект обновлен!"
    else
      render :edit
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :category, :feedback_request, :image)
  end
end