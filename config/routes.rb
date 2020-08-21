Rails.application.routes.draw do
  root 'user_sessions#new'

  resources :users
  resources :user_sessions
  get 'signin' => 'user_sessions#new'
  post 'signout' => 'user_sessions#destroy'

  namespace :dashboard do
    get 'index'
  end
end
