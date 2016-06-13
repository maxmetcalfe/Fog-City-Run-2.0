Rails.application.routes.draw do
  get 'welcome/index'
  get "/pages/:page" => "pages#show"
end

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
end
