Rails.application.routes.draw do
  resource :profile, only: [:show, :edit, :update], controller: :users

  # resources :password_resets, only: [:edit, :update]
  post :password_reset, to: 'password_resets#create'
  get :password_reset, to: 'password_resets#new'

  get '/auth/:provider/callback', to: 'authentications#create'
  get '/auth/failure', to: 'authentications#failure'

  post :register, to: 'registrations#create'
  get :register, to: 'registrations#new'

  post :authenticate, to: 'authentications#complete_registration'
  get :authenticate, to: 'authentications#new'
  
  delete :logout, to: 'sessions#destroy'
  post :login, to: 'sessions#create'
  get :login, to: 'sessions#new'

  root to: 'sessions#new'
end
