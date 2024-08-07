class NewPostNotiJob < ApplicationJob
  queue_as :default

  def perform(post)
    User.find_each do |user|
      PostMailer.new_post_noti(user,post).deliver_now
    end
  end
end
