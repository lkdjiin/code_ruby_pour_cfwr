class LikeController < BaseController
  def update
    @quote = Quote[params["id"]]
    @quote.likes += 1
    @quote.save
    render_json "quotes/like.json.erb", status: 299
  end
end
