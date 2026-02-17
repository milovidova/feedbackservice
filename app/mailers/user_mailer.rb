class UserMailer < ApplicationMailer
  def welcome_email
    @code = params[:code]
    email = params[:email]

    mail(to: email, subject: "Ваш код подтверждения")
  end
end