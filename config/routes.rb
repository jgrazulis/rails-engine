Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchant_search#find'
      get '/items/find_all', to: 'item_search#find_all'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
      resources :items, except: [:edit] do
        resources :merchant, only: [:index], controller: :item_merchant
      end
    end
  end
end
