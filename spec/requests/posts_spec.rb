require 'rails_helper'

RSpec.describe "Posts", type: :request do

  let(:user) { User.create(email: "user@example.com", password: "password") }
  let(:user2) { FactoryBot.create(:user) }

  describe "GET /posts" do
    it "renders all posts" do
      get "/posts"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /posts/new" do
    it "renders a new post form" do

      sign_in user
      get "/posts/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /posts/:id" do
    let(:post) { FactoryBot.create(:post, user: user) }
    it "shows a post" do
      # post = user.posts.create(title: "Test Post", conntent: "This is a test post")
      sign_in user
      get "/posts/#{post.id}"
      expect(response).to have_http_status(:success)
      # expect(response.body).to include(post.title)
      # expect(response.body).to include(post.conntent)
    end

    it "unauthenticated user show post" do
      post = FactoryBot.create(:post, title: "Testing", conntent: "Testing", user_id: user.id)

      get "/posts/#{post.id}"
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(user_session_path)
    end

  end


  describe "POST /posts" do
    it "creates a new post" do

      post_params = { post: { title: "New Post", conntent: "This is a new post", user_id: user.id } }
      sign_in user

      expect {
        post "/posts", params: post_params
      }.to change(Post, :count).by(1)

      expect(response).to redirect_to(post_path(Post.last))
    end

    it "creates a new post by unauthenticated user" do
      post_params = {post: {title: "Test by Unautorized user", conntent: "Testing by unauthorized user content"} }

      post '/posts', params: post_params

      expect(response).to redirect_to(user_session_path)
    end
  end



  describe "PATCH /posts/:id" do
    it "updates a post" do
      sign_in user
      post = user.posts.create(title: "Test Post", conntent: "This is a test post")

      updated_title = "Updated Post Title"
      patch "/posts/#{post.id}", params: { post: { title: updated_title } }
      post.reload
      expect(post.title).to eq(updated_title)
      expect(response).to redirect_to(post_path(post))
    end

    it "update post by unauthenticated user" do
      post = FactoryBot.create(:post)

      updated_title = "Update post title"
      patch "/posts/#{post.id}", params: { post: {title: updated_title}}

      expect(response).to redirect_to(user_session_path)
    end

    it "updates a post by unauthorized user" do

      post = user.posts.create(title: "Test Post", conntent: "This is a test post")
      sign_in user2
      updated_title = "Updated Post Title"
      patch "/posts/#{post.id}", params: { post: { title: updated_title } }
      post.reload

      expect(response).to redirect_to(posts_path)
    end

  end

  describe "DELETE /posts/:id" do
    it "destroys a post" do
      post = user.posts.create(title: "Test Post", conntent: "This is a test post")
      sign_in user

      expect {
        delete "/posts/#{post.id}"
      }.to change(Post, :count).by(-1)

      expect(response).to redirect_to(posts_path)
    end

    it "Destroy a post by unauthorized user" do
      post = user.posts.create(title: "Test post", conntent: "This is test post content")

      sign_in user2

      delete "/posts/#{post.id}"

      expect(response).to redirect_to(posts_path)

    end

    it "Destroys post by unauthenticated user" do
      post = FactoryBot.create(:post)

      delete "/posts/#{post.id}"

      expect(response).to redirect_to(user_session_path)
    end
  end
end
