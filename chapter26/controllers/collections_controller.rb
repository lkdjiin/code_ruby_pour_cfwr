class CollectionsController < BaseController
  def index
    collections = Collection.where(user_id: params["user_id"])
    render_json collections
  end

  def show
    @collection = Collection[params["id"]]
    render_json "collections/show.json.erb"
  end

  def new
  end

  def create
    collection = Collection.create(name: params["name"],
                                   tags: params["tags"],
                                   user_id: params["user_id"])
    render_json collection
  end

  def edit
  end

  def update
  end

  def delete
    @collection = Collection[params["id"]].delete
    render_json "collections/delete.json.erb"
  rescue NoMethodError => ex
    @error = { "code" => 1001, "message" => "No ID #{params["id"]}" }
    render_json "collections/error.json.erb", status: 400
  end
end
