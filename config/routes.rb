Rails.application.routes.draw do
  namespace :api do
    resources :users, except: [:destroy]
    resources :courses do
      member do
        post :registration, action: :register
        delete :registration, action: :unregister
      end
    end
  end
end
