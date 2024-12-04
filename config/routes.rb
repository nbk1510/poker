Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  post "/api/v1/cards/check", to: "api/v1/cards#check"
  post "/check", to: "home#check"
end
