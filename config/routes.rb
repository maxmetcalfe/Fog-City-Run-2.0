Rails.application.routes.draw do

  resources :racers do
    resource :results
    collection { post :import }
  end

  resources :results do
    collection { post :import }
  end

  resources :races do
    resource :results
    collection { post :import }
  end
 
  root 'welcome#index'
  get 'welcome/index'
  get '/count' => 'pages#count'
  get '/records' => 'pages#records'
  get '/import' => 'pages#import'
  get '/loop_beer' => 'pages#loop_beer'
end
