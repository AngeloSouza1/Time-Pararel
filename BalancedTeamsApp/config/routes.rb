Rails.application.routes.draw do
  resources :players, only: [:index] do
    collection do
      get 'select_players'
      post 'form_teams'
    end
  end

  root to: 'players#select_players'
end

