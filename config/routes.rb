Rails.application.routes.draw do
  scope "(:locale)", locale: /en|bn/ do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  authenticate :user do
    root "dashboard#index"

    resources :trucks do
      member do
        post :update_location
      end
      resources :location_logs, only: [:index]
    end

    resources :drivers

    resources :driver_assignments, only: [:index, :create, :destroy]

    resources :products
    resources :product_categories

    resources :locations
    resources :routes

    resources :shipments do
      member do
        patch :update_status
      end
      resources :status_logs, only: [:index]
    end

    resources :notifications, only: [:index, :update] do
      collection do
        post :mark_all_read
      end
    end

    resources :settings, only: [:index, :update]

    namespace :reports do
      get :daily
      get :weekly
      get :monthly
      get :truck_wise
      get :driver_wise
      get :product_wise
    end

    resources :audit_logs, only: [:index]
  end
  end
end
