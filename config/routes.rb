Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        # resources :market_vendors, only: [:index]
        resources :vendors, only: [:index ]
      end
      # resources :vendors, only: [:show]
      
    end
  end
end
