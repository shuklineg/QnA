Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        post :best
        post :delete_file
      end
    end
  end
end
