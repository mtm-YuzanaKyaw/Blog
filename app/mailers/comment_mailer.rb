class CommentMailer < ApplicationMailer
  default from: "notifications@example.com"

  def new_comment_noti(user,comment)
    @user = user
    @comment = comment
    mail(to:@user.email,subject:"New comment on your post")
  end


end
