Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :professionals do
    resources :appointments do 
      collection do 
        delete 'destroy_all', action: "destroy_all"
      end
    end
  end
  post 'professionals/download_day_pfd', to: "appointments#download_day"
  post 'professionals/download_week_pdf', to: "appointments#download_week"
  root to: 'professionals#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
