Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'



  resources :users
  resources :cart_items
  resources :orders
  resources :items
  resources :user_roles, only: [:new, :create]

  get 'code', to: redirect('https://github.com/larsonkonr/dinner_dash')
  root 'restaurants#index'

  namespace :admin do
    resources :items
    resources :users, only: [:index, :show]

    resources :orders do
      collection do
        get :ordered
        get :cancelled
        get :paid
        get :completed
      end

      member do
        put :pay
        put :complete
        put :cancel
      end
    end

    resources :categories, only: [:new, :create, :index]
  end
  #resources :restaurants, only: [:new, :create, :show, :edit, :update] do
   # resources :items
  #end
  #
  resources :restaurants do
    resources :categories, only: [:new, :create, :index, :destroy, :edit, :update], module: 'restaurant'
    resources :items, module: 'restaurant'
  end
end
