class NewPostNotiJob < ApplicationJob

  def perform(post)
    recipients = User.all
    PostMailer.new_post_noti(recipients,post).deliver_now
  end
end
