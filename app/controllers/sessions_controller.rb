class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  # 이미 로그인된 사용자는 'require_authentication' 필터를 넘길 수 있도록 설정
  before_action :require_authentication, except: [:new, :create, :omniauth, :destroy]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    # terminate_session
    # redirect_to new_session_path
    session[:user_id] = nil
    redirect_to root_path, notice: "성공적으로 로그아웃되었습니다."
  end

  def omniauth
    auth = request.env["omniauth.auth"]
    logger.info("==== OmniAuth 정보 ====")
    Rails.logger.debug "Auth hash: #{request.env['omniauth.auth'].to_json}"
    logger.info("=====================")

    user = User.find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |u|
      u.email = auth["info"]["email"]
      u.password = SecureRandom.hex(15) # 랜덤 패스워드 설정 (필수)
      u.name = auth["info"]["name"]
      u.image_url = auth["info"]["image"]
    end

    session[:user_id] = user.id
    # logger.info("로그인 후 세션 정보: #{session[:user_id]}")
    redirect_to root_path
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end
