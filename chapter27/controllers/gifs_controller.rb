class GifsController < BaseController
  def new
    url = "#{base_api}/gifs/create?collection_id=#{wall_id}"
    response = Net::HTTP.get_response(URI.parse(url))
    if json?
      render_json JSON.parse(response.body), status: response.code.to_i
    else
      notify_feedback(response.code)
      redirect_to "/walls/show?id=#{wall_id}"
    end
  end

  def delete
    url = "#{base_api}/gifs/delete?id=#{params["id"]}"
    response = Net::HTTP.get_response(URI.parse(url))
    if json?
      render_json response.body
    else
      redirect_to "/walls/show?id=#{wall_id}"
    end
  end

  private

  def wall_id
    params["wall_id"]
  end

  def notify_feedback(code)
    notice(code == "200" ? "Enjoy this new gif" : "Something went wrong :/")
  end

  def json?
    params["format"] == "json"
  end
end
