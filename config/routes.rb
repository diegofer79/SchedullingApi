Rails.application.routes.draw do
  resources :working_days
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/doctors', to: 'doctors#index'
  post '/doctors', to: 'doctors#create'
  delete '/doctors/:id', to: 'doctors#destroy'
  patch '/doctors/:id', to: 'doctors#update'

  get '/doctors/:id/working_days', to: 'doctors#working_days'
  get '/doctors/:id/appointments', to: 'doctors#appointments'
  get '/doctors/:id/open_slots', to: 'doctors#open_slots'
  
  resources :appointments, only: [:show, :create, :update, :destroy]
  patch '/appointments', to: 'appointments#update'
  
  resources :working_days, only: [:create, :destroy]
  patch '/working_days', to: 'working_days#update'

end
