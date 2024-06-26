Rails.application.routes.draw do
  root "articles#index"
  
  resources :okpds do
    post :upload, on: :collection
  end
  
  resources :fz44s do
    post :upload, on: :collection
    get :temp_table, on: :collection
    delete :destroy, on: :collection
  end
  
  resources :fz223s do
    post :upload, on: :collection
    get :temp_table, on: :collection
    delete :destroy, on: :collection
  end

  resources :customs do
    post :upload, on: :collection
    get :temp_table, on: :collection
  end
  
  resources :listokpds do
    post :upload, on: :collection
  end
  
  resources :reports do
    get :okpd_group, on: :collection
  end

  resources :articles do
    get :data, on: :collection
  end

  resources :proms do
    post :upload, on: :collection
    get :temp_table, on: :collection
  end

  resources :temps do
    get :show_table, on: :collection
    post :show_table, on: :collection
    post :all_graph, on: :collection
    get :all_graph, on: :collection
    get :auto_complete_okpd, on: :collection
    get :product_direction, on: :collection
    get :product_direction_ajax, on: :collection
    get :navig_okpd, on: :collection
    get :dashboard, on: :collection
    post :dashboard, on: :collection
  end

  resources :product_directions do
    post :upload, on: :collection
  end

  resources :temp_years do
    collection do
      match 'search' => 'temp_years#index', via: [:get, :post], as: :search
    end
  end
  
  resources :temp_years
  resources :product_directions
  resources :temps
  resources :proms
  resources :customs
  resources :reports
  resources :okpds
  resources :fz44s
  resources :fz223s
  resources :listokpds
  resources :tables
  resources :articles
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create]

end
