Rails.application.routes.draw do
  devise_for :users
  resources :boards do
    resources :posts
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'about', :to => 'pages#about'
  root 'pages#about'
end
