class PostMailer < ApplicationMailer
  default from: "notifications@example.com"

  def new_post_noti(users,post)
    @user = users
    @post = post
    emails = @user.collect(&:email).join(",")
    mail(to:emails,subject:"New post was created")

  end



end
