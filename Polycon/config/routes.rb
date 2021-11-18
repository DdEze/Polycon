Rails.application.routes.draw do
  resources :professionals do
    resources :appointments do 
        collection do 
          delete 'destroy_all', action: "destroy_all"
        end
    end
  end
  #mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: 'professionals#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
