class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :events, dependent: :destroy
  after_create :send_welcome_email

  def self.from_google(auth)

    User.find_or_create_by(uid: auth.uid, provider: auth.provider) do |u|
      u.email = auth.info.email
      u.name = auth.info.name
      u.password = Devise.friendly_token[0,20]
      u.google_token = auth.credentials.token
      u.google_refresh_token = auth.credentials.refresh_token
    end
  end

  private
  def send_welcome_email
    UserMailer.welcome_user(self).deliver_now
  end

end
