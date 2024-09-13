require 'rails_helper'

RSpec.describe "Users", type: :request do


  describe "POST /users" do
    it "redirect to new page after new regiteration" do
      user_params = { user: { email: "new_user@gmail.com", password: "password", password_confirmation: "password" } }

      expect {
        post "/users", params: user_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)

    end
  end

  describe "POST /users/sign_in" do
    let(:user) { User.create(email: "example@gmail.com", password: "password") }

    it "user sign_in with valid credential" do
      post user_session_path , params: {
        user: { email: user.email, password: user.password }
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
      follow_redirect!

      # expect(response.body).to include("<span>Welcome! You have signed up successfully.</span>")

    end

    it "user sign in with invalid credentials" do
      post user_session_path, params: {
        user: {email: user.email, password: "123456"}
      }

      expect(response).to have_http_status(:unprocessable_entity)

    end

  end

  describe "Delete /users/sign_out" do
    let(:user) { User.create(email: 'example@gmail.comm', password: "password") }
    it "Logout and redirect to root page" do
      delete destroy_user_session_path, params: {
        user: {email: user.email, password: user.password}
      }

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "PATCH /users" do
    user = FactoryBot.create(:user)
    it "Update user profile" do
      updated_email = "updatedtesting@gmail.com"
      sign_in user

      patch "/users", params: { user: {email: updated_email, password:user.password} }
      user.reload

      expect(user.email).to eq('updatetesting@gmail.com')
      # expect(response).to have_http_status(:redirect)
      # expect(response).to redirect_to(root_path)

    end
  end

end
