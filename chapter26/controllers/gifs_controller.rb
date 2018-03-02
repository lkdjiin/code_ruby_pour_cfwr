class GifsController < BaseController
  def random
    @gif = Gif.random(collection_id: params["collection_id"])
    render_json "gifs/show.json.erb"
  rescue
    @error = { "status" => 404, "message" => "Not found. Try with fewer tags." }
    render_json "gifs/error.json.erb", status: 404
  end

  def delete
    gif = Gif[params["id"]].delete
    render_json gif
  end
end
