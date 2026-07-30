LicenseEngine::Engine.routes.draw do
  resources :telemetry_tokens

  resources :companies do
    member do
      patch :activate
      patch :deactivate
    end
    resource :licenses do
      collection do
        get :bulk_edit
        patch :bulk_update
      end
    end
    resources :telemetry_tokens, only: [:index]
  end

  get "licenses/validate", to: "licenses#validate"
  resources :licenses do
    member do
      post "checkout"
      post "checkin"
    end
  end

  post "licenses/checkout_available", to: "licenses#checkout_available"

  get "companies/status/:id", to: "home#status"

  get "home/index"
  root to: "home#index"
  get "activity", to: "home#activity", as: :activity
  get "status", to: "home#status", as: :status
  get "no_company", to: "home#nocompany", as: :no_company
end
