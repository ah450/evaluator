Rails.application.routes.draw do
  namespace :api do
    resources :users, except: [:destroy, :new]
    resources :courses do
      member do
        post :registration, action: :register
        delete :registration, action: :unregister
      end
      resources :projects, shallow: true, except: [:new]
    end
  end
end
