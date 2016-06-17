Rails.application.routes.draw do

  resources :racers do
    resource :results
  end

  resources :results do
  end

  resources :races do
    resource :results
  end
 
  root 'welcome#index'
  get 'welcome/index'
  get '/count' => 'pages#count'
  get '/records' => 'pages#records'
end
