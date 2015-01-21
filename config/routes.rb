Rails.application.routes.draw do
  post :register, to: 'registrations#create'
  get :register, to: 'registrations#new'

  get 'auth/:provider/callback', to: 'authentications#create'
  get 'auth/failure', to: 'authentications#failure'

  post :authenticate, to: 'authentications#complete_registration'
  get :authenticate, to: 'authentications#new'

  post :login, to: 'sessions#create'
  get :login, to: 'sessions#new'
  delete :logout, to: 'sessions#destroy'

  resource :profile, only: [:show, :edit, :update], controller: :users
end
