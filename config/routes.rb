Rails.application.routes.draw do
  root 'user_sessions#new'

  resources :users, only: [:new, :create]
  resources :user_sessions
  get 'signup' => 'users#new'
  get 'signin' => 'user_sessions#new'
  get 'signout' => 'user_sessions#destroy'

  get 'dashboard' => 'dashboard#index'
  namespace :dashboard do
    get 'index'
    get 'items'
    post 'import_item_csv'
    get 'orders'
    get 'shops'
    get 'members'
  end

  namespace :api do
    resources :members, only: [:update]
  end


  get 'auth/callback/:key' => 'dashboard#base_auth_callback'
end
