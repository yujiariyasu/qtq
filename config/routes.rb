Rails.application.routes.draw do
  get 'sessions/new'

  resources :users, only: [:show]
  root 'users#show'
end
