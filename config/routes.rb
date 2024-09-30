Rails.application.routes.draw do
  get 'movies/index', to: 'movies#index'
  post 'movies/search', to: 'movies#search'
  post 'movies/show', to: 'movies#show'
  root to: 'movies#index'

  match '(*path)', via: :all, to: redirect('/404')
end