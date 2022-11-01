Rails.application.routes.draw do
  resources :events
  root 'welcome#index'
  get "/auth/:provider/callback" => "sessions#create"
  delete "/logout" => "sessions#destroy"
  # 適当ページのroutingです。
  get "/test" => "tests#index"
end
