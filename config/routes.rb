require 'sidekiq/web'

SubversionStats::Application.routes.draw do
  devise_for :admins
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  root :to => "home#index"
  resources :projects, :committers, :commits, :changes, :stats, :uploads
  mount Sidekiq::Web, at: '/sidekiq'
end
