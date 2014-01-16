WyshmeApi::Application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  namespace :api do
    resources :users, except: [:new] do
      get :me, on: :collection
    end

    resources :lists, except: [:new]

    resources :items, except: [:new] do
      put :like, on: :member
      put :wysh, on: :member
    end

    resources :categories, except: [:new] do
      get :featured_items
    end
    get '/categories/featured_items', to: "categories#all_featured_items"
    resources :events
  end

  root to: 'static_pages#index'

  match '*path', to: 'application#cors_preflight_check', via: [:options]

end
