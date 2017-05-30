class UserMailer < ApplicationMailer
  ##
  #
  ##
  def confirm_email(user)
    user.generate_confirm_token!

    @user = user
    @url = "https://sensly.io/confirm_email?confirm=#{user.confirm_token.token}"

    mail(to: @user.email, subject: 'Confirm your email address')
  end
end
