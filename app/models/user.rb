class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email, presence: true, uniqueness: true

  def self.from_omniauth(auth)
    user = find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.email = auth["info"]["email"]
      user.password = SecureRandom.hex(15)

      # 추가 정보 저장
      user.name = auth["info"]["name"]
      user.image_url = auth["info"]["image"]
    end
  end
end
