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




  get "pages/about"      
  get "pages/profile"    
  get "pages/articles"
 

get 'telegram/app', to: 'telegram#app'
get 'telegram/projects', to: 'telegram#projects' 
get 'telegram/my_projects', to: 'telegram#my_projects' 
post 'telegram/create_project', to: 'telegram#create_project'
post 'telegram/projects/:project_id/feedbacks', to: 'telegram#create_feedback'

  # resources :projects
  # post '/waitlist', to: 'waitlists#create'

  get 'projects/grid', to: 'projects#grid', as: :grid_projects
  get 'projects/arth', to: 'projects#arth', as: :arth_projects    
  get 'projects/artp', to: 'projects#artp', as: :artp_projects 

    resources :projects do
    resources :feedbacks, only: [:create]  
  end
  post '/waitlist', to: 'waitlists#create'
end
