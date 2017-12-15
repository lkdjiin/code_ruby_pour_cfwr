class DislikeController < BaseController
  def update
    @quote = Quote[params["id"]]
    @quote.dislikes += 1
    @quote.save
    [200, {'Content-Type' => 'application/json'}, [@quote.to_json]]
  end
end
