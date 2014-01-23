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
      get :featured, on: :collection
      get :liked, on: :collection
      get :wyshed, on: :collection
    end

    resources :categories, except: [:new] do
      get :featured_items, on: :member
      get :featured_items, on: :collection, to: :all_featured_items
    end

    resources :events
  end

  root to: 'static_pages#index'

  match '*path', to: 'application#cors_preflight_check', via: [:options]

end
