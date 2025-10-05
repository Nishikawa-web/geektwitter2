Rails.application.routes.draw do
  get "pages/top"
  devise_for :users
  get "hello/index" => "hello#index"

  get "hello/link" => "hello#link"


  get 'tweets/:tweet_id/likes' => 'likes#create'
  get 'tweets/:tweet_id/likes/:id' => 'likes#destroy'
  resources :tweets

  root "pages#top"
  resources :tweets do
    resources :likes, only: [:create, :destroy]
  end

  get 'maps/index'

  resources :maps, only: [:index]

end
