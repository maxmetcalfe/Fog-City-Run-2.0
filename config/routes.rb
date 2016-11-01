Rails.application.routes.draw do

  resources :racers do
    resource :results
    collection { post :import }
  end

  resources :results do
    collection { post :import }
    collection { post :upload }
    collection { post :read_import }
  end

  resources :races do
    resource :results
    collection { post :import }
  end

  resources :users do
  end

  resources :orders do
  end
 
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
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

end