Rails.application.routes.draw do

  root 'welcome#index'
  get "/auth/:provider/callback" => "sessions#create"
  delete "/logout" => "sessions#destroy"
  resources :events
  resources :events do
    resources :tickets
  end
  # 適当ページのroutingです。
  get "/test" => "tests#index"
end
