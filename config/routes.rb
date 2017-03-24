Rails.application.routes.draw do
  devise_for :members
  root to: 'logins#index'
  get '/main', to: 'mains#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/admins', to: 'admins#index'
  get '/admins/users', to: 'admins#users'
  get '/admins/users/set_admin', to: 'admins#set_admin'
  get '/admins/users/set_access', to: 'admins#set_access'
  get '/admins/user_profile', to: 'admins#profile'
  get '/member', to: 'members#index'
  resources :admins
  post '/auth', to: 'api#validate_web'
  get '/request', to: 'api#request_server_api'
end
