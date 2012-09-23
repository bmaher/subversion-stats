require 'sidekiq/web'

SubversionStats::Application.routes.draw do
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  root :to => "home#index"
  resources :projects, :committers, :commits, :changes
  constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.has_role? :admin }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end
end
