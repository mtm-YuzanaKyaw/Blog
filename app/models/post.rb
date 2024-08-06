require 'csv'

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments

  after_create :notify_all_users


  require 'csv'
def self.to_csv
 posts = all
 CSV.generate do |csv|
   csv << column_names
   posts.each do |post|
     csv << post.attributes.values_at(*column_names)
   end
 end
end

private

def notify_all_users
  User.find_each do |user|
    PostMailer.new_post_noti(user, self).deliver_now
  end
end
end
