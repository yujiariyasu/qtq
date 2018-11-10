Rails.application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  get '/auth/:provider/callback', to: 'users#create', as: :auth_callback
  resources :user_relationships, only: [:create, :destroy]
  root to: 'sessions#new'
  get '*anything' => 'errors#routing_error'
end
