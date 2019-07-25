Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  resource :authorization, only: %i[new create] do
    get 'email_confirmation/:confirmation_token', action: :email_confirmation, as: :email_confirmation
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :users do
    resources :rewards, only: %i[index]
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :questions, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable] do
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index]
    end
  end
end
