Application.routes.config do
  get "", route_to: "connections#new"
  post "/connections/new", route_to: "connections#create"

  get "/walls", route_to: "walls#index"
  post "/walls/new", route_to: "walls#create"
  get "/walls/show", route_to: "walls#show"
  get "/walls/delete", route_to: "walls#delete"

  get "/gifs/new", route_to: "gifs#new"
  get "/gifs/delete", route_to: "gifs#delete"
end
