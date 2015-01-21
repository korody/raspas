Rails.application.routes.draw do
  resource :profile, only: [:show, :edit, :update], controller: :users

  get 'auth/:provider/callback', to: 'authentications#create'
  get 'auth/failure', to: 'authentications#failure'

  post :register, to: 'registrations#create'
  get :register, to: 'registrations#new'

  delete :logout, to: 'sessions#destroy'
  post :login, to: 'sessions#create'
  get :login, to: 'sessions#new'
end
