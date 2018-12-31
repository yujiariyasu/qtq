Rails.application.routes.draw do
  resources :users do
    member do
      get :following, :followers
    end
  end
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/auth/:provider/callback', to: 'users#create', as: :auth_callback
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :user_relationships, only: [:create, :destroy]
  resources :learnings do
    resources :learning_likes, only: [:create, :destroy]
    member do
      get :likers
    end
  end
  resources :reviews
  resources :comments, only: [:create, :destroy, :update] do
    resources :comment_likes, only: [:create, :destroy]
  end
  root to: 'users#show' do

  end
  get '*anything' => 'errors#routing_error'
end
