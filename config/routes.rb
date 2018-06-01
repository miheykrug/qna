Rails.application.routes.draw do
  get 'attachments/destroy'
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
  end
  resources :attachments, only: %i[destroy]

  mount ActionCable.server => '/cable'
end
