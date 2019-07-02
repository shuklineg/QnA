Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :users do
    resources :rewards, only: %i[index]
  end

  concern :votable do
    member do
      post :vote_up
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: :votable do
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
