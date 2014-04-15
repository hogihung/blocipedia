Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  get 'home/about'
  get 'home/contact'

  resources :users, only: [:update]
  resources :wikis

  root to: 'home#index'

end
