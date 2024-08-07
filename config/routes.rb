require 'sidekiq/web'
Rails.application.routes.draw do
  get 'myposts', to: 'posts#myposts'

  get 'calendars', to: 'events#calendars'
  get '/events/:calendar_id', to: 'events#index', as: 'calendar_events', calendar_id: /[^\/]+/
  get 'new/:calendar_id', to: 'events#new', as: 'new_event', calendar_id: /[^\/]+/
  post 'create/:calendar_id', to: 'events#create', as: 'create_event', calendar_id: /[^\/]+/
  get '/events/:calendar_id/:event_id', to: 'events#edit', as: 'calendar_event_edit',
      calendar_id: /[^\/]+/, event_id: /[^\/]+/
  put '/events/:calendar_id/:event_id', to: 'events#update', as: "calendar_event_update",
      calendar_id: /[^\/]+/, event_id: /[^\/]+/
  delete '/events/:calendar_id/:event_id', to: 'events#destroy', as: "calendar_event_destroy",
      calendar_id: /[^\/]+/, event_id: /[^\/]+/

  resources :posts do
    resources :comments

    collection do
      get 'export_csv'
      get 'import_csv'
      # post 'import_csv_process'
      post 'post_import_process'
    end
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  # get 'auth/:provider/callback', to: 'sessions#googleAuth'
  # get 'auth/failure', to: redirect('/')

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  mount Sidekiq::Web => '/sidekiq'
end
