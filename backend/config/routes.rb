Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :posts, only: [:index, :show] do
        member do
          get :transform
          post :post_to_x
        end
      end
      
      resources :keywords
      
      get 'scheduled_tasks/fetch_posts', to: 'scheduled_tasks#fetch_posts'
    end
  end
end
