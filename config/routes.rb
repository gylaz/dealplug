Dealplug::Application.routes.draw do
  devise_for :users
  resources :users
  resources :votes
  resources :deals

  match "popular" => "deals#index", :popular => true, :as => :popular

  root :to => "deals#index"
end
