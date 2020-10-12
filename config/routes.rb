Rails.application.routes.draw do
  root 'user_sessions#new'

  resources :users, only: [:new, :create]
  resources :user_sessions
  get 'signup' => 'users#new'
  get 'signin' => 'user_sessions#new'
  get 'signout' => 'user_sessions#destroy'

  get 'dashboard' => 'dashboard#index'
  namespace :dashboard do
    resources :items do
      post :import_csv, on: :collection
      post :load_supplier_data, on: :collection
    end
    resources :orders, only: [:index] do
      post :load_detail, on: :collection
    end
    resources :members, only: [:index, :update]
    resources :shops, only: [:index]
  end
  get 'auth/callback/:key' => 'dashboard#base_auth_callback'
end
