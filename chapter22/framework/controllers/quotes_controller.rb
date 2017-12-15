class QuotesController < BaseController
  def show
    fail "Boom!"
    @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
    render_json @quote
  end
end
