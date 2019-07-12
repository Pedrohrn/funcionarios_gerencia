Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'usuarios#index'

  resources :grupos, 		only: [:index, :create, :update, :destroy, :show] do
  	collection do
  		put :micro_update
  	end
  end
  resources :cargos, 		only: [:index, :create, :update, :destroy, :show] do
  	collection do
  		put :micro_update
  	end
  end
  resources :recessos,  only: [:index, :create, :update, :destroy, :show]
  resources :usuarios, 	only: [:index, :show]
end

