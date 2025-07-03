Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }


  resources :folders
  resources :lists do
    resources :tasks
  end

  root to: "lists#index"

  get "up" => "rails/health#show", as: :rails_health_check
  match "*unmatched", to: "application#not_found", via: :all
end
