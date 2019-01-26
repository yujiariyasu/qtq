Rails.application.routes.draw do
  resources :users, param: :name do
    resources :learnings, only: :index
    resources :activities, only: :index do
      collection do
        patch :check
      end
    end
    member do
      get :following, :followers
      get :like, to: 'learnings#liked'
      get :timeline, to: 'learnings#timeline'
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
      get :search
    end
  end
  resources :reviews, only: :create
  resources :comments, only: [:create, :destroy, :update] do
    resources :comment_likes, only: [:create, :destroy]
  end
  resources :subscriptions, only: :create
  resources :activities, only: :update
  resources :tags, param: :name, only: :show
  root to: 'top#root'
  get '*anything' => 'errors#routing_error'
end
