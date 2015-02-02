Rails.application.routes.draw do
  get :validate, to: 'validations#validate', defaults: { format: :json }

  resources :password_resets, only: [:new, :create, :edit, :update]
  resource :profile, only: [:show, :edit, :update], controller: :users

  resources :auth_registrations, only: [:new, :create]

  get '/auth/failure', to: 'authentications#failure'
  get '/auth/:provider/callback', to: 'authentications#create'

  post :register, to: 'registrations#create'
  get :register, to: 'registrations#new'

  delete :logout, to: 'sessions#destroy'
  post :login, to: 'sessions#create'
  get :login, to: 'sessions#new'

  root to: 'sessions#new'
end
