class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"

  def user_signup(user)
    @user = user

    mail to: user.email_address, subject: "Please register with Crossroads Lodge!"
  end
end
