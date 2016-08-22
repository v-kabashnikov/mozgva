Rails.application.routes.draw do
  devise_scope :user do
    patch '/users/send_confirmation' => "users/registrations#send_confirmation", as: :send_confirmation
    post '/users/check_confirmation' => "users/registrations#check_confirmation", as: :check_confirmation
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :leagues, only: [:index]
  resources :game_registrations, only: [:create]
  resources :members, only: [:destroy] do
    put 'set_boatswain', on: :member, as: :set_boatswain
  end
  resources :teams, only: [:create, :destroy, :update] do
    get 'list', on: :collection
  end
  get 'games/filter', to: 'games#filter', as: :games_filter
  delete 'games/:id/unregister', to: 'games#unregister', as: :game_unregister

  resources :invitations, only: [:create, :destroy] do
    member do
      get 'accept'
      get 'decline'
    end
  end
  get '/team', to: 'teams#my_team', as: :my_team
  get '/calendar', to: 'home#calendar'
  get '/franchise', to: 'home#franchise'
  get '/korporat', to: 'home#korporat'
  get '/sert', to: 'home#sert'
  get '/faq', to: 'team_ratings#faq'
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords'}
  post '/users/search', to: 'users#search', as: :users_search
  put '/users/update_city', to: 'users#update_city', as: :update_city
  get '/rating', to: 'team_ratings#rating', as: :rating
  root 'home#index'

  get '/i/:invite', to: 'invitations#invite_reg', as: :invite
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
