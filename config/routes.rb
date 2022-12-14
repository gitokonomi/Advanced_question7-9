Rails.application.routes.draw do
  get 'chats/show'
  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  # test用ページ
  get "book/test"=> "books#test"

  # チャット
  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]


  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/search', to: 'searches#search'
  get '/search_tag', to: 'searches#search_tag'  
end
