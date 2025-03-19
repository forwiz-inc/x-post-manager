Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :keywords
      resources :posts, only: [:index, :show] do
        member do
          post :generate
          post :publish
        end
      end
      resources :generated_posts
      
      # 認証関連のルート
      get 'auth/authorize', to: 'auth#authorize'
      get 'auth/callback', to: 'auth#callback'
      get 'auth/status', to: 'auth#status'
      
      # スケジュールタスク関連のルート
      post 'scheduled_tasks/fetch_posts', to: 'scheduled_tasks#fetch_posts'
    end
  end
end
