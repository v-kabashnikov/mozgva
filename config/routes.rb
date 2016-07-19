Rails.application.routes.draw do
  resources :leagues, only: [:index]
  resources :teams, only: [:create, :destroy, :update]
  resources :invitations, only: [:create, :destroy] do
    member do
      get 'accept'
      get 'decline'
    end
  end
  get '/team', to: 'teams#my_team', as: :my_team
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
  post '/users/search', to: 'users#search', as: :users_search
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
