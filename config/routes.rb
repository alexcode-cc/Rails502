Rails.application.routes.draw do
  resources :boards do
    resources :posts
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "pages#about"
end
