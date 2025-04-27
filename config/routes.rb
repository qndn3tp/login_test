Rails.application.routes.draw do
  resource :session, only: [ :new, :create, :destroy ]
  resources :passwords, param: :token
  get "up" => "rails/health#show", as: :rails_health_check

  # 사용자 정의 콜백 핸들러
  get "/auth/:provider/callback", to: "sessions#omniauth"
  get "/auth/failure", to: redirect("/")

  root to: "sessions#new"
end
