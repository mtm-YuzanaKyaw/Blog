class NewPostNotiWorker
  include Sidekiq::Worker
  queue_as :default

  def perform(id)
    post = Post.find(id)
    recipients = User.all

    PostMailer.new_post_noti(recipients,post).deliver_now
  end
end
