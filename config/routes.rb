Rails.application.routes.draw do

  get 'welcome/index'

  resources :racers do
    resource :results
  end

  resources :results do
  end

  resources :races do
    resource :results
  end
 
  root 'welcome#index'

  get '/about' => 'pages#about'
end
