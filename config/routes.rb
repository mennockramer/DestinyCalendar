Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => 'devise/omniauth_callbacks',
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "calendar#index"

  namespace :calendar do
    get 'index'
  end

  resources :calendar_entries
end
