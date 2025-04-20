Rails.application.routes.draw do
  get "pages/about"
  get "home/index"
  
  # current_userのリポジトリで十分だから、usersのネストの外に書いている
  resources :repositories do
    get :file_search_suggestions, on: :member
  end

  resources :annotations, only: [:create, :destroy] do
    resources :annotation_likes, only: [:create, :destroy]
  end

  resources :users, only: [] do
    get :mypage, on: :member
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"

  resources :tags, param: :name, only: [:show]
end
