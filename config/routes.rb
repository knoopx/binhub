BinHub::Application.routes.draw do
  resources :releases do
    resources :files do
      resources :segments
    end
  end
  resources :files
  resources :segments
  resources :articles
  resources :groups
  resources :regular_expressions do
    resources :segments
  end

  root to: "releases#index"
end
