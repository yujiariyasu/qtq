Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  root 'users#show'
  resources :users, only: [:show, :new, :create, :edit, :update]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
