Rails.application.routes.draw do
  namespace :api do
    resources :users, except: [:destroy, :new] do
      member do
        get :reset_password, action: :reset_password
        get :confirm_reset, action: :confirm_reset
        get :resend_verify, action: :resend_verify
        get :verify, action: :verify
      end
    end
    resources :courses do
      member do
        post :registration, action: :register
        delete :registration, action: :unregister
      end
      resources :projects, shallow: true, except: [:new]
    end
    resources :tokens, only: [:create]
    resources :configurations, only: [:index]
  end

# For non api namespaced paths
resources :users, only: [] do
  member do
    get :confirm_reset, action: :confirm_reset
    get :verify, action: :verify
  end
end
end
