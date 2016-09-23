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
 
  root 'welcome#index'
  get 'welcome/index'
  get '/count' => 'pages#count'
  get '/records' => 'pages#records'
  get '/import' => 'results#upload'
  get '/loop_beer' => 'pages#loop_beer'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
  match 'sessions/:id/claim' => 'sessions#claim', via: [:patch, :put], as: :claim

end