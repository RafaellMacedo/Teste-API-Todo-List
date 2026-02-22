Rails.application.routes.draw do
  post "/item", to: "list_items#store"

end
