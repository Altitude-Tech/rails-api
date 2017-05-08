class UserMailer < ApplicationMailer
  ##
  #
  ##
  def confirm_email(user)
    @user = user
    @url = 'http://sensly.io/confirm'

    mail(to: @user.email, subject: 'Confirm your email address')
  end
end
