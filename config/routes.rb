Rails.application.routes.draw do
  get 'home/index'
  get 'home/about'
  get 'home/contact'

  root to: 'home#index'

end
