class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  after_create :comment_noti

  private
  def comment_noti
    # id = self.id
    NewCommentNotiJob.perform_now(self)
  end
end
