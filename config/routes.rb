Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'usuarios#index'

  resources :grupos, 		only: [:index]
  resources :cargos, 		only: [:index]
  resources :usuarios, 	only: [:index]
end

