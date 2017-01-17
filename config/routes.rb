Rails.application.routes.draw do

  resources :racers do
    resource :results
    collection do
      post :import
      get 'autocomplete_racer'
    end
  end

  resources :results do
    collection { post :import }
    collection { post :upload }
    collection { post :read_import }
  end

  resources :races do
    resource :results
    collection { post :import }
    collection { patch :start }
  end
  
  resources :start_items do
  end

  resources :users do
  end

  resources :orders do
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
 
  root 'welcome#index'
  get 'welcome/index'
  get '/count' => 'pages#count'
  get '/records' => 'pages#records'
  get '/import' => 'results#upload'
  get '/loop_beer' => 'pages#loop_beer'
  get '/safety' => 'pages#safety'
  get '/singup' => 'sessions#new'
  get '/login' => 'sessions#new'
  get '/shop' => 'pages#shop'
  get 'password_resets/new'
  get 'password_resets/edit'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
  get :send_results_email, to: 'races#send_results_email', as: :send_results_email
  put 'races/:id/start' => 'races#start_race', :as => 'start_race'
  put 'races/:id/stop' => 'races#stop_race', :as => 'stop_race'
  post 'start_items/:id/collect_time' => 'start_items#collect_time', :as => 'collect_time'
  post 'start_items/:id/continue_time' => 'start_items#continue_time', :as => 'continue_time'

end