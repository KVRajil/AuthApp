class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Account Confirmation')
  end

  def send_otp(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: 'One time password')
  end
end
