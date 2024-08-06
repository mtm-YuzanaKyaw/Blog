# Preview all emails at http://localhost:3000/rails/mailers/user_mailer_mailer
class UserMailerPreview < ActionMailer::Preview
  def welocme_mail
    UserMailer.welcome_user
  end
end
