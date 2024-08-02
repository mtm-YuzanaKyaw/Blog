require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:hehe) { FactoryBot.create(:post, user: user) }
  let(:comment_params) { { comment: { comment: "This is a test comment.", user_id: user.id } } }

  describe "GET /posts/:post_id/comments" do
    let(:comment) { FactoryBot.create(:comment) }
    it "shows all comments on post" do
      sign_in user

      get "/posts/#{hehe.id}/comments"

      expect(response).to have_http_status(200)
    end
  end
  describe "POST /posts/:post_id/comments" do
    it "creates a new comment on a post" do
      sign_in user  # Assuming Devise is used and sign_in helper is available
      expect {
        post post_comments_path(post_id: hehe.id), params: comment_params
      }.to change(hehe.comments, :count).by(1)

      expect(response).to redirect_to(post_path(hehe))
      follow_redirect!

      expect(response.body).to include("Comment was successfully created.")
    end
  end
end
