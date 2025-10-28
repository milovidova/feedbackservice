class WaitlistsController < ApplicationController
  def create
    @waitlist = Waitlist.new(waitlist_params)
    
    if @waitlist.save
      redirect_to pages_profile_path, notice: "Спасибо! Мы сообщим вам о запуске!"
    else
      flash[:alert] = @waitlist.errors.full_messages.join(", ")
      redirect_to pages_profile_path
    end
  end

  private

  def waitlist_params
    params.require(:waitlist).permit(:email)
  end
end