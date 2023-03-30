Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    root to: "products#index"
    
    post "/products", to: "products#create"
    put "/products/:id", to: "products#update"
    get "/products/:id", to: "products#show"

    # leave search via names to front end

    get "/health", to: proc { [200, {}, ["OK"]] }
  end
end
