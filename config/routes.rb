Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :users do
    resources :rewards, only: %i[index]
  end

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
