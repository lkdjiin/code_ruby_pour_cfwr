Application.routes.config do
  get "/v1/gifs/create", route_to: "gifs#random"
  get "/v1/gifs/delete", route_to: "gifs#delete"

  get "/v1/collections", route_to: "collections#index"
  get "/v1/collections/show", route_to: "collections#show"
  post "/v1/collections/create", route_to: "collections#create"
  get "/v1/collections/delete", route_to: "collections#delete"

  post "/v1/users/create", route_to: "users#create"
  get "/v1/users/show", route_to: "users#show"
end
