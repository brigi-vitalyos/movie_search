Rails.application.routes.draw do
  get 'movies/index'
  post 'movies/search'
  root to: 'movies#index'

  match '(*path)', via: :all, to: redirect('/404')
end