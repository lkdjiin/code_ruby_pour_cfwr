Application.routes.config do

  get "/posts", route_to: "posts#index"
  get "/posts/new", route_to: "posts#new"
  get "/posts/show", route_to: "posts#show"
  get "/posts/delete", route_to: "posts#delete"
  post "/posts/new", route_to: "posts#create"
  get "/posts/edit", route_to: "posts#edit"
  post "/posts/edit", route_to: "posts#update"

end
