SubversionStats::Application.routes.draw do

  root :to => "home#index"
  resources :projects, :committers, :commits, :changes, :stats, :uploads
end
