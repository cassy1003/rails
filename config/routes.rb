Rails.application.routes.draw do
  get 'user_sessions/new'
  get 'user_sessions/create'
  get 'users/new'
  get 'users/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboard#index'

  namespace :dashboard do
    get 'index'
  end
end
