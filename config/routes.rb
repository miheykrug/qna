require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  get 'attachments/destroy'
  get 'users/edit_email'
  patch 'users/update_email'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

  concern :votable do
    member do
      post :rating_up
      post :rating_down
      delete :rating_cancel
    end
  end

  concern :commentable do
    resources :comments, only: %i[create], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, only: %i[create update destroy], shallow: true, concerns: [:votable, :commentable] do
      member do
        put :best
      end
    end
    resource :subscriptions, only: %i[create destroy]
  end

  resources :attachments, only: %i[destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create] do
        resources :answers, only: %i[index show create], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
