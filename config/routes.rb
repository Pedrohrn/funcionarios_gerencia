Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'usuarios#index'

  resources :recessos,  only: [:index, :create, :update, :destroy, :show]

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

  resources :usuarios, 	only: [:index, :show, :create, :update, :destroy] do
    collection do
      put :micro_update
    end
  end

end

