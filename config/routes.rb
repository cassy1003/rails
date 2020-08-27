Rails.application.routes.draw do
  root 'user_sessions#new'

  resources :users
  resources :user_sessions
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
