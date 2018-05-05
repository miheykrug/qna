Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      member do
        put :best
      end
    end
  end
end
