Rails.application.routes.draw do
  get "/item", to: "list_items#index"
  post "/item", to: "list_items#store"
  put "/item", to: "list_items#update"
  delete "/item", to: "list_items#destroy"
end
