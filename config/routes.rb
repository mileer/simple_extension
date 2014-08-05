Spree::Core::Engine.routes.draw do
  resources :addresses
  get "/admin/orders/:id/courier_instruction" => "admin/orders#courier_instruction", 
        :as => :orders_courier_instruction
  get "/orders/:id/sberbank_invoice" => "orders#sberbank_invoice", :as => :orders_sberbank_invoice
  
  namespace :admin do
    resource :simple_settings, :only => [:show, :edit, :update]
  end
  
  get "/admin/orders/:id/juridical_info" => "admin/orders#juridical_info", :as => :orders_juridical_info
  get "/orders/:id/juridical_invoice" => "orders#juridical_invoice", :as => :orders_juridical_invoice
  
  resource :account, :controller => "users" do
    get :edit_status
    patch :update_status
  end
end
