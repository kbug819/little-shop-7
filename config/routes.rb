Rails.application.routes.draw do
  get "/merchants/:merchant_id/dashboard", to: "merchants#show", as: :dashboard_merchants
  get "/merchants/:merchant_id/items", to: "merchants/items#index", as: :merchant_items
  get "/merchants/:merchant_id/items/new", to: "merchants/items#new", as: :new_merchant_item
  post "/merchants/:merchant_id/items", to: "merchants/items#create"
  patch "/merchants/:merchant_id/items/status", to: "merchants/items#update", as: :status_merchant_item
  get "merchants/:merchant_id/items/:item_id", to: "merchants/items#show", as: :merchant_item
  get "/merchants/:merchant_id/items/:item_id/edit", to: "merchants/items#edit", as: :edit_merchant_item
  patch "/merchants/:merchant_id/items/:item_id", to: "merchants/items#update"
  get "/merchants/:merchant_id/invoices", to: "merchants/invoices#index"
  patch "/merchants/:merchant_id/invoices/:invoice_id/:item_id", to: "merchants/invoices#update", as: :merchant_invoice_item
  get "/merchants/:merchant_id/invoices/:invoice_id", to: "merchants/invoices#show", as: :merchant_invoice
  
  get "/merchants/:merchant_id/discounts", to: "merchants/discounts#index", as: :merchant_discounts
  get "/merchants/:merchant_id/discounts/new", to: "merchants/discounts#new", as: :new_merchant_discount
  get "/merchants/:merchant_id/discounts/:discount_id", to: "merchants/discounts#show", as: :merchant_discount
  post "/merchants/:merchant_id/discounts", to: "merchants/discounts#create"
  get "/admin", to: "admin#index"
  
  namespace :admin do 
    resources :merchants, except: [:destroy]
    resources :invoices, only: [:index, :show, :update]
  end

  # resources :merchants, only: [:show] do
  #   resources :dashboard
  #   resources :invoices
  #   resources :discounts
  #   resources :items do
  #     resources :status
  #   end
  # end
  
  # resources :merchants, only: [] do
  #   collection do
  #     get ':merchant_id/dashboard', to: 'merchants#show', as: :dashboard
  #   end
    
  #   resources :items, controller: 'merchants/items', param: :item_id do
  #     member do
  #       get 'edit', to: 'merchants/items#edit', as: :edit
  #       patch '', to: 'merchants/items#update'
  #       patch 'status', to: 'merchants/items#update', as: :status
  #     end
  #   end
    
  #   resources :invoices, controller: 'merchants/invoices', param: :invoice_id do
  #     member do
  #       patch '', to: 'merchants/invoices#update', as: :status
  #     end
  #   end
  # end  
end
