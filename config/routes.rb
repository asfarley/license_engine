Rails.application.routes.draw do
  resources :telemetry_tokens
  resources :jwt_blacklists

  devise_for :users, :controllers => { sessions: 'sessions', registrations: 'registrations'}, :path_prefix => 'my'
  get 'users/emails', to: 'users#emails'
  resources :users

  resources :companies do
    resource :licenses do
      collection do
          get :bulk_edit
          patch :bulk_update
        end
      end
    end
  resources :telemetry_tokens

  get 'licenses/validate', to: 'licenses#validate'
  resources :licenses do
    member do
      post 'checkout'
      post 'checkin'
    end
  end

  post 'licenses/checkout_available', to: 'licenses#checkout_available'
  patch 'users/set_admin/:id', to: 'users#set_admin'
  patch 'users/unset_admin/:id', to: 'users#unset_admin'
  patch 'companies/activate/:id', to: 'companies#activate'
  patch 'companies/deactivate/:id', to: 'companies#deactivate'
  get 'companies/status/:id', to: 'companies#status'
  get 'home/index'
  root to: 'home#index'
  get 'activity', to: 'home#activity'
  get 'status', to: 'home#status'
  get 'no_company', to: 'home#nocompany'
end
