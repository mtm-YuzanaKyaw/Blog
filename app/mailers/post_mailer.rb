class PostMailer < ApplicationMailer
  default from: "notifications@example.com"

  def new_post_noti(user,post)
    @user = user
    @post = post

    mail(to:user.email,subject:"New post was created")

  end
end
