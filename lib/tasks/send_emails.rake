namespace :emails do
  desc "Send welcome email with faker"
  task send_welcome_emails: :environment do
    require 'faker'

    300.times do
      User.create!(
        email: Faker::Internet.email,
        password: "123456"
      )
    end

    User.find_in_batches(batch_size: 50) do |batch|
      batch.each do |user|
        UserMailer.welcome_user(user).deliver_now
      end
      sleep 1
    end
    # User.find_each do |user|
    #   UserMailer.welcome_user(user).deliver_now
    # end

    puts "Email has been sent to all users"
  end

end
