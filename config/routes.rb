Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "projects#index"

  devise_for :users

  get "pages/about"
  get "pages/profile"
  get "pages/articles"
  get "/pages/create", to: "pages#create"
  get "article1", to: "pages#article1"
  get "article2", to: "pages#article2"
  get "article3", to: "pages#article3"
  get "article4", to: "pages#article4"
  get "article5", to: "pages#article5"
  get "article6", to: "pages#article6"

  get "telegram/app", to: "telegram#app"
  get "telegram/projects", to: "telegram#projects"
  get "telegram/my_projects", to: "telegram#my_projects"
  post "telegram/create_project", to: "telegram#create_project"
  post "telegram/projects/:project_id/feedbacks", to: "telegram#create_feedback"

  get "projects/grid", to: "projects#grid", as: :grid_projects
  get "projects/arth", to: "projects#arth", as: :arth_projects
  get "projects/artp", to: "projects#artp", as: :artp_projects

  get "/email_code",  to: "email_codes#new"
  post "/email_code", to: "email_codes#create"

  resources :projects do
    resources :feedbacks, only: [:create]
  end

  post "/waitlist", to: "waitlists#create"


  namespace :api, format: "json" do
    namespace :v1 do

      devise_scope :user do
        post "sign_up",          to: "registrations#create"
        post "sign_in",          to: "sessions#create"
        get  "authorize_by_jwt", to: "sessions#authorize_by_jwt"
        get  "sign_out",         to: "sessions#destroy"
      end

      resources :projects, only: [:index, :show, :create] do
        resources :feedbacks, only: [:create]
      end

      get "my_projects", to: "projects#my"
    end
  end
end