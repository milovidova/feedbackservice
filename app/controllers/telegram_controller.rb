class TelegramController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false
  

  def app

  end
  

  def projects
    @projects = Project.all.includes(:user, :feedbacks).order(created_at: :desc).limit(20)
    
    render json: @projects.as_json(
      only: [:id, :title, :description, :category, :feedback_request, :created_at],
      methods: [:image_url],
      include: {
        user: { only: [:id, :username] },
        feedbacks: { 
          only: [:id, :content, :created_at], 
          include: { user: { only: [:username] } }
        }
      }
    )
  end
  
  
  def my_projects
    current_user = User.first 
    
    @projects = current_user.projects.includes(:feedbacks).order(created_at: :desc)
    
    render json: @projects.as_json(
      only: [:id, :title, :description, :category, :feedback_request, :created_at],
      methods: [:image_url],
      include: {
        user: { only: [:id, :username] },
        feedbacks: { 
          only: [:id, :content, :created_at], 
          include: { user: { only: [:username] } }
        }
      }
    )
  end
  
 
  def create_project
    @project = Project.new(project_params)
    @project.user = User.first
    
    
    if params[:project][:image].present?
      @project.image = params[:project][:image]
    end
    
    if @project.save
      render json: { 
        success: true, 
        project: @project.as_json(
          only: [:id, :title, :description, :category, :created_at],
          methods: [:image_url],
          include: { user: { only: [:username] } }
        )
      }
    else
      render json: { 
        success: false, 
        errors: @project.errors.full_messages 
      }
    end
  end
  

  def create_feedback
    @project = Project.find(params[:project_id])
    @feedback = @project.feedbacks.new(feedback_params)
    @feedback.user = User.first 
    
    if @feedback.save
      render json: { 
        success: true, 
        feedback: @feedback.as_json(
          only: [:id, :content, :created_at], 
          include: { user: { only: [:username] } }
        )
      }
    else
      render json: { 
        success: false, 
        errors: @feedback.errors.full_messages 
      }
    end
  end
  
  private
  
  def project_params
    params.require(:project).permit(:title, :description, :category, :feedback_request, :image)
  end
  
  def feedback_params
    params.require(:feedback).permit(:content) 
  end
end