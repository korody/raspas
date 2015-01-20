Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'authentications#create'
  get 'auth/failure', to: 'authentications#failure'

  get :login, to: 'authentications#new'
  post :login, to: 'authentications#create'
  delete :logout, to: 'authentications#destroy'

  get 'profile/:id', to: 'users#show', as: :profile

  post :register, to: 'registrations#create'
  get :register, to: 'registrations#new'
end
