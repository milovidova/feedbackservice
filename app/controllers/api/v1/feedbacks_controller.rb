class Api::V1::FeedbacksController < ApplicationController
  include JwtAuth

  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!   
  before_action :load_user_by_jti

  def create
    project = Project.find(params.expect(:project_id))
    feedback = project.feedbacks.new(feedback_params)
    feedback.user = @user

    if feedback.save
      render json: {
        messages: "Feedback created",
        is_success: true,
        feedback: {
          id: feedback.id,
          content: feedback.content,
          category: feedback.category,
          is_helpful: feedback.is_helpful,
          user: { id: @user.id, email: @user.email }
        }
      }, status: :ok
    else
      render json: {
        messages: "Validation failed",
        is_success: false,
        errors: feedback.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def feedback_params
    params.expect(feedback: [:content, :category, :is_helpful])
  end
end