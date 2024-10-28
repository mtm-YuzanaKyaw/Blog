class NewCommentNotiJob < ApplicationJob

  def perform(comment)
    post = Post.find_by(id: comment.post_id);
    user = User.find_by(id: post.user_id);

    CommentMailer.new_comment_noti(user,comment).deliver_now

  end
end
