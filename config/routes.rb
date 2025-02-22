Rails.application.routes.draw do
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/merchants/:id/dashboard', to: 'merchants#show'
  get '/', to: 'welcome#index'
  get '/admin', to: 'admin#index' 

  resources :merchants do
    resources :items, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show]
  end

  namespace :admin do
    resources :merchants, only: [:index, :show, :edit, :update, :new, :create]
    resources :invoices, only: [:index, :show, :update]
  end
end
