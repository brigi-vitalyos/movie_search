Rails.application.routes.draw do
  get 'movies/index', tp: 'movies#index'
  post 'movies/search', to: 'movies#search'
  root to: 'movies#index'

  match '(*path)', via: :all, to: redirect('/404')
end