Rails.application.routes.draw do

  resources :airports, only: :show
  resources :carriers, only: :show
  get "*any", via: :all, to: "home#index"
end
