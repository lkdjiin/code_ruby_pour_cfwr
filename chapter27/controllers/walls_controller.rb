class WallsController < BaseController
  def index
    url = "#{base_api}/collections?user_id=#{params["user_id"]}"
    response = Net::HTTP.get_response(URI.parse(url))
    @walls = JSON.parse(response.body, object_class: OpenStruct)
    @user_id = user_id
    render "walls/index.html.erb"
  end

  def show
    url = "#{base_api}/collections/show?id=#{params["id"]}"
    response = Net::HTTP.get_response(URI.parse(url))
    @wall = JSON.parse(response.body, object_class: OpenStruct)
    @user_id = @wall.user_id
    render "walls/show.html.erb"
  end

  def new
  end

  def create
    query = {
      "name" => params["name"],
      "tags" => params["tags"],
      "user_id" => user_id
    }
    url = "#{base_api}/collections/create"
    Net::HTTP.post_form(URI.parse(url), query)
    redirect_to "/walls?user_id=#{user_id}"
  end

  def edit
  end

  def update
  end

  def delete
    url = "#{base_api}/collections/delete?id=#{params["id"]}"
    # On se servira de la réponse plus tard.
    response = Net::HTTP.get_response(URI.parse(url))
    redirect_to "/walls?user_id=#{user_id}"
  end

  private

  def user_id
    params["user_id"]
  end
end
