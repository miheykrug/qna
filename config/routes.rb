Rails.application.routes.draw do
  get 'attachments/destroy'
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      member do
        put :best
      end
    end
    member do
      post :rating_up
      post :rating_down
    end
  end
  resources :attachments, only: %i[destroy]
end
