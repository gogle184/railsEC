Rails.application.routes.draw do
  root to: 'top#index'
  devise_for :admins, only: [:session],
                      controllers: {
                        sessions: 'admins/sessions',
                      }
  namespace :admins do
    resources :products
    resources :users, only: %i[index show edit update destroy]
  end
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
  }
  resources :products, only: %i[show]
  resource :cart, only: %i[show] do
    resources :cart_items, module: :cart, only: %i[create update destroy]
  end
  resource :order, only: %i[create] do
    get :confirm
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
