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

    it "Update user profile" do
      user = FactoryBot.create(:user)
      sign_in user
      updated_email = "updatedtesting@gmail.com"
      patch user_registration_path, params: { user: {email: updated_email, current_password:user.password} }
      user.reload

      expect(user.email).to eq(updated_email)
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)

    end

    it "Update user password" do
      user = FactoryBot.create(:user)
      sign_in user
      updated_pwd = "12345678"
      patch user_registration_path, params: { user: { password: updated_pwd, password_confirmation: updated_pwd, current_password:user.password } }

      user.reload
      # expect(user.password).to eq(updated_pwd)
      expect(user.valid_password?(updated_pwd)).to be true
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include("Your account has been updated successfully.")
    end

    it "Update all information" do
      user = FactoryBot.create(:user)
      sign_in user
      # let {:valid_input} { {email: "update@example.com", password: "12345678", password_confirmation: "12345678"} }
      patch user_registration_path, params: {user: {email: "update@example.com", password: "12345678", password_confirmation: "12345678", current_password: user.password}}
      user.reload

      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(root_path)
    end
  end

end
