Rails.application.routes.draw do
  resources :users, only: [:show]
  root 'users#show'
end
