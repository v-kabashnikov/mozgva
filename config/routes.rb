Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
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
  post '/users/update_city', to: 'users#update_city', as: :update_city
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
