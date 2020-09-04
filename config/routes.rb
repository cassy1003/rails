Rails.application.routes.draw do
  root 'user_sessions#new'

  resources :users, only: [:new, :create]
  resources :user_sessions
  get 'signup' => 'users#new'
  get 'signin' => 'user_sessions#new'
  post 'signout' => 'user_sessions#destroy'
end
