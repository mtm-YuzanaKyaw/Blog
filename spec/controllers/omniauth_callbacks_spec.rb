require 'rails_helper'
require_relative '../support/omniauth_macros'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  before do
    mock_oauth_response(:google_oauth2, '123456', {
      email: 'test@example.com',
      name: 'Test User'
    })
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe 'GET #google_oauth2' do
    it 'signs in the user with Google OAuth' do
      get :google_oauth2

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Successfully authenticated from Google account.')
    end

    it 'creates a new user if they do not exist' do
      expect { get :google_oauth2 }.to change(User, :count).by(1)
      user = User.find_by(email: 'test@example.com')
      expect(user).to_not be_nil
      expect(user.name).to eq('Test User')
    end
  end
end
