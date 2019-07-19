Rails.application.routes.draw do
  root to: 'questions#index'

  devise_scope :user do
    get 'users/registration/auth', to: 'users/registrations#new_auth'
    post 'users/registration/auth', to: 'users/registrations#create_auth'
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    registrations: 'users/registrations'
  }

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
end
