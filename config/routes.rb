Rails.application.routes.draw do
  resources :users do
    resources :learnings, only: :index
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
  resources :learnings, except: :index do
    resources :learning_likes, only: [:create, :destroy]
    member do
      get :likers, to: 'users#likers'
    end
    collection do
      get :trend
    end
  end
  resources :reviews
  resources :comments, only: [:create, :destroy, :update] do
    resources :comment_likes, only: [:create, :destroy]
  end
  resources :subscriptions, only: :create
  resources :tags, only: :show
  root to: 'top#root'
  get '*anything' => 'errors#routing_error'
end
