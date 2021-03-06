Rails.application.routes.draw do

  get '/online', to: 'groceries#shop'

  resources :maps

  get '/search', to: 'recipes#search'
  get '/recipes/search', to: 'recipes#search_by_name'
  resources :recipes, only: [:show, :index, :cook]
  post '/recipes/:id/groceries', to: 'recipes#add_groceries'
  

  get '/cook', to: 'recipes#cook'
  get '/recipes/:id/cook', to: 'recipes#cook'
  post '/plans/:id/create_groceries', to: 'groceries#create_from_plan'
  post '/recipes/:id/create_groceries', to: 'groceries#create_from_recipe'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}
  get 'welcome/index'


  resources :users do
    resources :groceries, only: [:index, :new, :create, :update, :destroy]
  end

  resources :plans
  # get 'users/edit'
  # get 'users/update'
  delete 'users/:user_id/groceries/clear_checked' => 'groceries#delete', as: :clear_checked
  delete 'users/:user_id/groceries/clear_unchecked' => 'groceries#delete', as: :clear_unchecked

end
