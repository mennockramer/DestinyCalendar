Rails.application.routes.draw do
  get 'calendar/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "calendar#index"
end
