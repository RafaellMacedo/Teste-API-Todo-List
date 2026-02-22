Rails.application.routes.draw do
  get "/item", to: "list_items#index"
  post "/item", to: "list_items#store"
end
