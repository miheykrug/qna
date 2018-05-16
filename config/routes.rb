Rails.application.routes.draw do
  get 'attachments/destroy'
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :rating_up
      post :rating_down
      delete :rating_cancel
    end
  end
  resources :questions, concerns: [:votable] do
    resources :answers, only: %i[create update destroy], shallow: true, concerns: [:votable] do
      member do
        put :best
      end
    end
  end
  resources :attachments, only: %i[destroy]
end
