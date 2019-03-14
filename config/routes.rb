Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/about',   to: 'static_pages#about'
  resources :alumni do
    collection { post :import}
  end
  resources :events do
    collection { post :import}
  end
  resources :attendances, only: [:new, :create, :destroy] do
    collection { post :import}
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
