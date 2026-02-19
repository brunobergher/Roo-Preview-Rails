require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#index"
  post "increment", to: "home#increment"
  get "ping", to: "home#ping"
  resources :testimonials, only: %i[index create]
end
