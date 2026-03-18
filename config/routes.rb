Rails.application.routes.draw do
  root 'books#index'
  resources :books, only: [:index, :show]
  resources :authors, only: [:index, :show]
  resources :subjects, only: [:index, :show]
  get '/about', to: 'pages#about'
end