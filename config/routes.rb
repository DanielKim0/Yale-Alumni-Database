Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  resources :alumni do
    member do
      get :alumni
    end
  end
  resources :events do
    member do
      get :events
    end
  end
  resources :attendances, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
