class ConnectionsController < BaseController
  def new
    render "connections/new.html.erb"
  end

  def create
    url = "#{base_api}/users/show?name=#{params["login"]}"
    response = Net::HTTP.get_response(URI.parse(url))
    user = JSON.parse(response.body)
    redirect_to "/walls?user_id=#{user["id"]}"
  end
end
