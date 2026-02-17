class EmailCodesController < ApplicationController
  def new
    render :yourmail
  end

  def create
    email = params[:email]
    code  = rand(100000..999999).to_s

    UserMailer.with(email: email, code: code).welcome_email.deliver_now

    redirect_to email_code_path, notice: "Код отправлен на почту"
  end
end
