class FeedbacksController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @feedback = @project.feedbacks.new(feedback_params)
    @feedback.user = current_user  

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @project, notice: "Фидбек успешно добавлен!" }
        format.json do
          render json: {
            success: true,
            feedback: {
              content: @feedback.content,
              category: @feedback.category,
              is_helpful: @feedback.is_helpful,
              user: { username: @feedback.user.username }
            }
          }
        end
      else
        format.html do
          redirect_to @project,
                      alert: "Ошибка при добавлении фидбека: " + @feedback.errors.full_messages.join(", ")
        end
        format.json do
          render json: {
            success: false,
            errors: @feedback.errors.full_messages.join(", ")
          }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:content, :category, :is_helpful)
  end
end