namespace :emails do

  desc "send notification email for new post created"
  task send_noti_emails: :environment do
    require 'faker'

    post = Post.create!(
      title: Faker::Book.title,
      conntent: Faker::Quote.matz,
      user_id: 8
    )

    User.find_in_batches(batch_size: 50) do |batch|
      batch.each do |user|
        PostMailer.new_post_noti(user,post).deliver_now
      end
      sleep 1
    end
    puts "Email has been sent to all users"

  end

end
