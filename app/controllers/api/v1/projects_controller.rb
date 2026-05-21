class Api::V1::ProjectsController < ApplicationController
  include JwtAuth

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!   # <— вот этой строки не хватает

  before_action :load_user_by_jti, only: [:create, :my]

  def index
    bearer = request.headers["Authorization"]
    unless bearer.present?
      render json: { messages: "Unauthorized - missing token", is_success: false }, status: :unauthorized and return
    end

    token = bearer.split(' ').last

    begin
      jwt_signing_key = Rails.application.credentials.jwt_signing_key!
      payload, header = JWT.decode(token, jwt_signing_key, true, { algorithm: 'HS256' })
    rescue JWT::DecodeError
      render json: { messages: "Unauthorized - invalid token", is_success: false }, status: :unauthorized and return
    end

    jti = payload['jti']
    user = User.find_by_jti(jti)

    unless user
      render json: { messages: "Unauthorized - user not found", is_success: false }, status: :unauthorized and return
    end

    projects = Project.includes(:user).all

    render json: projects.as_json(
      only: [:id, :title, :description, :category, :feedback_request],
      include: {
        user: { only: [:id, :email] }
      }
    )
  end

  def my
    projects = @user.projects

    render json: projects.as_json(
      only: [:id, :title, :description, :category, :feedback_request]
    )
  end

  def show
    project = Project.includes(feedbacks: :user).find(params.expect(:id))

    render json: project.as_json(
      only: [:id, :title, :description, :category, :feedback_request],
      include: {
        user: { only: [:id, :email] },
        feedbacks: {
          only: [:id, :content, :category, :is_helpful, :created_at],
          include: {
            user: { only: [:id, :email] }
          }
        }
      }
    )
  end

  def create
    project = @user.projects.build(project_params)

    if project.save
      render json: {
        messages: "Project created",
        is_success: true,
        id: project.id
      }, status: :ok
    else
      render json: {
        messages: "Validation failed",
        is_success: false,
        errors: project.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def project_params
    params.expect(project: [:title, :description, :category, :feedback_request])
  end
end