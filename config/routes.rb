Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'funcionarios#index'

  resources :funcionario_recessos,  only: [:index, :destroy, :show] do
    collection do
      post :submit
    end
  end

  resources :funcionario_grupos, 		only: [:index, :destroy, :show] do
  	collection do
      post :submit
  		put :micro_update
  	end
  end

  resources :funcionario_cargos, 		only: [:index, :destroy, :show] do
  	collection do
      post :submit
  		put :micro_update
  	end
  end

  resources :funcionarios, 	        only: [:index, :show, :destroy] do
    collection do
      post :submit
      put :micro_update
    end
  end

end

