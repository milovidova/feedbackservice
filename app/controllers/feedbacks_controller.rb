
class FeedbacksController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @feedback = @project.feedbacks.new(feedback_params)
    @feedback.user = User.first  
    
    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @project, notice: 'Фидбек успешно добавлен!' }
        format.json { 
          render json: { 
            success: true, 
            feedback: {
              content: @feedback.content,
              category: @feedback.category,
              is_helpful: @feedback.is_helpful,
              user: { username: @feedback.user.username }
            }
          } 
        }
      else
        format.html { 
          redirect_to @project, 
          alert: 'Ошибка при добавлении фидбека: ' + @feedback.errors.full_messages.join(', ') 
        }
        format.json { 
          render json: { 
            success: false, 
            errors: @feedback.errors.full_messages.join(', ') 
          }, 
          status: :unprocessable_entity 
        }
      end
    end
  end
  
  private
  
  def feedback_params
    params.require(:feedback).permit(:content, :category, :is_helpful)
  end
end