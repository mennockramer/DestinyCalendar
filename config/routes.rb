Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "calendar#index"

  namespace :calendar do
    get 'index'
  end

  resources :calendar_entries
end
