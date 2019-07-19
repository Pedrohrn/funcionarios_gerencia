Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'usuarios#index'

  resources :recessos,  only: [:index, :destroy, :show] do
    collection do
      post :submit
    end
  end

  resources :grupos, 		only: [:index, :destroy, :show] do
  	collection do
      post :submit
  		put :micro_update
  	end
  end

  resources :cargos, 		only: [:index, :destroy, :show] do
  	collection do
      post :submit
  		put :micro_update
  	end
  end

  resources :usuarios, 	only: [:index, :show, :destroy] do
    collection do
      post :submit
      put :micro_update
    end
  end

end

