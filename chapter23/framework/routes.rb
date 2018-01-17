Application.routes.config do
  get "/v1/test", route_to: "test#show"
  get "/hello", route_to: "hello#index"
end
