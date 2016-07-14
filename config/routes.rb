Rails.application.routes.draw do
  resources :leagues, only: [:index]
  resources :teams, only: [:create, :destroy, :update]
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
