class UserMailer < ApplicationMailer
  default from: 'gymk225@gmail.com'

  def confirmation_email(user)
    @user = user
    @confirmation_token = user.confirmation_token
    mail(to: @user.email, subject: 'Confirmation Instructions')
  end

  def send_otp(email, otp)
    @otp = otp
    mail(to: email, subject: 'Your OTP for Password Reset')
  end
  
end
