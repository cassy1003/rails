Rails.application.routes.draw do
  root 'user_sessions#new'

  resources :users, only: [:new, :create]
  resources :user_sessions
  get 'signup' => 'users#new'
  get 'signin' => 'user_sessions#new'
  post 'signout' => 'user_sessions#destroy'

  get 'dashboard' => 'dashboard#index'
  namespace :dashboard do
    get 'index'
    get 'items'
    get 'orders'
  end

  get 'auth/callback/:key' => 'user_sessions#callback'
end
