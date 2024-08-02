require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#comments.build" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post, user: user) }

    it "builds a new comment associated with the post" do
      new_comment = post.comments.build(comment: "Test comment content")

      expect(new_comment).to be_a(Comment)
      expect(new_comment).to be_new_record  # Assert that it's a new record (not yet saved)
      expect(new_comment.post).to eq(post)  # Assert that it's associated with the correct post
    end
  end
end
