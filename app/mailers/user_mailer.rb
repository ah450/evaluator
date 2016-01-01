class UserMailer < ApplicationMailer
  default from: 'evaluator@evaluator.in'

  def pass_reset_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm password reset')
  end

  def verification_email(user)
    @user = user
    mail(to: @user.email, subject: 'Verify your account')
  end
  
end
