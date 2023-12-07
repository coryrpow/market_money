Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :markets, only: [:index, :show] do
        
        resources :vendors, module: :markets, only: [:index ]
      end
      resources :vendors, only: [:show, :create, :update, :destroy] do
        
      end
      resources :market_vendors, only: [:create]
    end
  end
end
