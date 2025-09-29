Rails.application.routes.draw do
  devise_for :users
  get "hello/index" => "hello#index"

  get "hello/link" => "hello#link"


  get 'tweets/:tweet_id/likes' => 'likes#create'
  get 'tweets/:tweet_id/likes/:id' => 'likes#destroy'
  resources :tweets

  root to: 'tweets#index'
  resources :tweets do
    resources :likes, only: [:create, :destroy]
  end

  get 'maps/index'
  root to: 'maps#index'
  resources :maps, only: [:index]

end
