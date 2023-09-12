Rails.application.routes.draw do
  get "/merchants/:merchant_id/dashboard", to: "merchants#show"
  get "/merchants/:merchant_id/items", to: "merchant_items#index"
  get "/merchants/:merchant_id/invoices", to: "merchant_invoices#index"
  get "/merchants/:merchant_id/invoices/:invoice_id", to: "merchant_invoices#show", as: :merchant_invoice

  get "/admin", to: "admin#index"
  
  namespace :admin do 
    resources :merchants, only: [:index]
    resources :invoices, only: [:index]
  end
end
