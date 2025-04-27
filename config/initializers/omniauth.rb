Rails.application.config.middleware.use OmniAuth::Builder do
    OmniAuth.config.allowed_request_methods = [ :get, :post ]

    provider :google_oauth2,
              ENV["GOOGLE_CLIENT_ID"],
              ENV["GOOGLE_CLIENT_SECRET"],
             {
               scope: "email, profile",
               prompt: "select_account",
               access_type: "online",
               redirect_uri: "http://localhost:3000/auth/google_oauth2/callback",
               provider_ignores_state: true
             }

    provider :kakao,
              ENV["KAKAO_CLIENT_ID"]

    provider :naver,
            ENV["NAVER_CLIENT_ID"],
            ENV["NAVER_CLIENT_SECRET"]
  end
