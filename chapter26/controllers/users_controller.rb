class UsersController < BaseController
  def show
    @user = params["id"] ? User[params["id"]] : User[{name: params["name"] }]
    render_json "users/show.json.erb"
  end

  def create
    user = User.create(name: params["name"])
    render_json user
  end
end
