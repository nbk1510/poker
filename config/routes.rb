Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  post "/check", to: "home#check"

  post "/api/v1/cards/check", to: "api/v1/cards#check"
end
