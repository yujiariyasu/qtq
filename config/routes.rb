Rails.application.routes.draw do
  root 'users#show'
  resources :users, only: [:show]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
