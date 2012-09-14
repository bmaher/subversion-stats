require 'sidekiq/web'

SubversionStats::Application.routes.draw do

  root :to => "home#index"
  resources :projects, :committers, :commits, :changes, :stats, :uploads
  mount Sidekiq::Web, at: '/sidekiq'
end
