module OmniauthMacros
  def mock_oauth_response(provider, uid, info = {})
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: uid,
      info: info
    )
  end
end

RSpec.configure do |config|
  config.include OmniauthMacros
end
