Bookstore::Application.routes.draw do
  

  post "users/login"
  get "users/login"

  get "users/logout"

  get "users/delete"
  get "users/create"

  get "users/edit"

  get "users/welcome"
  get "users/hidden"

  get "users/forgot_password"

  resources :authors
  resources :books
  resources :users
  root :to => 'users#login'
end
