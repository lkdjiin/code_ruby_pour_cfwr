# --- Une nouvelle appli avec sqlite
# Fichier Gemfile
source "https://rubygems.org/"
ruby "~> 2.4.0"
gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sequel', '~> 4.43.0'
gem 'sqlite3'


# --- Le modèle Quote
# Fichier models/quote.rb
class Quote < Sequel::Model
end


# --- Une table pour les citations
# Fichier db/migrations/01_create_quotes.rb
Sequel.migration do
  change do
    create_table(:quotes) do
      primary_key :id
      String :character, :text=>true
      String :quote, :text=>true
      Integer :likes
      Integer :dislikes
    end
  end
end


# --- Un affichage très simple
# Fichier controllers/quotes_controller.rb
class QuotesController < BaseController
  def index
    @quotes = Quote.all
    p @quotes
    [200, {}, ["OK"]]
  end
end


# --- Une première route
# Fichier routes.rb
Application.routes.config do
  get "/quotes", route_to: "quotes#index"
end


# --- Trouver une citation
# Fichier controllers/quotes_controller.rb
class QuotesController < BaseController
  def show
    @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
    p @quote
    [200, {}, ["OK"]]
  end
end


# --- Une route pour une citation
Application.routes.config do
  get "/quotes", route_to: "quotes#index"
  get "/quotes/show", route_to: "quotes#show"
end


# --- Le plugin JSON pour Sequel
# Fichier lib/application.rb
DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration").chomp,
                    logger: Logger.new("logs/db.log"))
Sequel::Model.plugin :json_serializer
Dir.glob('models/*.rb') { |filename| require_relative("../#{filename}") }


# --- Avec le bon content-type
# Fichier controllers/quotes_controller.rb
class QuotesController < BaseController
  def show
    @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
    [200, {'Content-Type' => 'application/json'}, [@quote.to_json]]
  end
end


# --- Deux nouvelles routes et leurs contrôleurs
# Fichier controllers/like_controller.rb
class LikeController < BaseController
  def update
    @quote = Quote[params["id"]]
    @quote.likes += 1
    @quote.save
    [200, {'Content-Type' => 'application/json'}, [@quote.to_json]]
  end
end
# Fichier controllers/dislike_controller.rb
class DislikeController < BaseController
  def update
    @quote = Quote[params["id"]]
    @quote.dislikes += 1
    @quote.save
    [200, {'Content-Type' => 'application/json'}, [@quote.to_json]]
  end
end
# Fichier routes.rb
Application.routes.config do
  get "/quotes", route_to: "quotes#index"
  get "/quotes/show", route_to: "quotes#show"
  post "/quotes/like", route_to: "like#update"
  post "/quotes/dislike", route_to: "dislike#update"
end


# --- La classe Application
# Fichier lib/application.rb
class Application
  include Error

  def self.routes
    @@routes
  end

  def initialize(logger:)
    @@routes = Routes.new
    require "./routes"
    FrameworkLogger.instance.logger = logger
  end

  def call(env)
    route = @@routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    notice = Notice.new(env)
    req = Rack::Request.new(env)
    route.exec_with(req.params, notice)
  rescue E404 => ex
    env["framework.api"] ? api_error_404 : error_404
  rescue
    env["framework.api"] ? api_error_500 : error_500
  end
end


# --- Une nouvelle méthode
# Fichier controllers/like_controller.rb
class LikController < BaseController
  def update
    @quote = Quote[params["id"]]
    @quote.likes += 1
    @quote.save
    render_json "quotes/like.json.erb", status: 299
  end
end


# --- Un template
# Fichier views/quotes/like.json.erb
{"id":<%= @quote.id %>,"likes":<%= @quote.likes %>}


# --- Implémentation de render_json
# Fichier lib/base_controller.rb
class BaseController

  def render(filename)
    @binding = binding
    status, body = Renderer.new(File.join('views', filename), @binding).render
    [status, @headers, [body]]
  end

  def render_json(filename, status: 200)
    @binding = binding
    body = APIRenderer.new(File.join('views', filename), @binding).render
    [status, @headers.merge!({'Content-Type' => 'application/json'}), [body]]
  end
end


# --- La classe APIRenderer
# Fichier lib/application.rb
require_relative 'api_renderer'
# Fichier lib/api_renderer.rb
class APIRenderer

  def initialize(filename, binding)
    @filename = filename
    @binding = binding
  end

  def render
    ERB.new(template).result(@binding)
  end

  def template
    File.read(@filename)
  end
end


# --- Les routes préfixées
Application.routes.config do
  get "/v1/quotes/show", route_to: "quotes#show"
  post "/v1/quotes/like", route_to: "like#update"
  post "/v1/quotes/dislike", route_to: "dislike#update"
end


# --- La méthode show avant
def show
  @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
  [200, {'Content-Type' => 'application/json'}, [@quote.to_json]]
end


# --- La méthode show après
class QuotesController < BaseController
  def show
    @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
    render_json @quote
  end
end


# --- Tiens ! De la doc !
class BaseController
  # Le paramètre `object` doit être un nom de template, ou bien doit accepter
  # la méthode `to_json`.
  def render_json(object, status: 200)
    @binding = binding
    body = APIRenderer.new(object, @binding).render
    [status, @headers.merge!({'Content-Type' => 'application/json'}), [body]]
  end
end


# --- La classe APIRenderer finale
class APIRenderer

  def initialize(filename_or_object, binding)
    @object = filename_or_object
    @binding = binding
  end

  def render
    if view?
      ERB.new(template).result(@binding)
    else
      @object.to_json
    end
  end

  def template
    File.read(view_file)
  end

  def view?
    @object.is_a?(String) && File.exists?(view_file)
  end

  def view_file
    File.join('views', @object)
  end

end


# --- Gestion de l'erreur 404
class Application
  include Error

  def call(env)
    # ...
  rescue E404 => ex
    env["framework.api"] ? api_error_404 : error_404
  end
end


# --- La méthode api_error_404
# Fichier lib/error.rb
module Error
  def api_error_404
    [
      404,
      {"Content-Type" => "application/json"},
      [{error: "Not found"}.to_json]
    ]
  end
end


# --- Gestion de l'erreur 500
class Application
  include Error

  def call(env)
    # ...
  rescue => ex
    env["framework.api"] ? api_error_500(ex.message) : error_500
  end
end


# --- La méthode api_error_500
module Error
  def api_error_500(msg)
    [
      500,
      {"Content-Type" => "application/json"},
      [{error: "Server Error. #{msg}"}.to_json]
    ]
  end
end


# --- Simulons une erreur du serveur
class QuotesController < BaseController
  def show
    fail "Boom!"
    @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
    render_json @quote
  end
end


# --- La gem nokogiri
source "https://rubygems.org/"
ruby "~> 2.4.0"
gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sequel', '~> 4.43.0'
gem 'sqlite3'
gem 'nokogiri', '~> 1.8.0'


# --- Le plugin XML pour Sequel
# Fichier lib/application.rb
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :xml_serializer


# --- Du XML ! Du XML ! Du …
# Fichier controllers/quotes_controller.rb
class QuotesController < BaseController
  def show
    @quote = Quote.where(Sequel.ilike(:character, params["character"])).first
    render_xml @quote
  end
end


# --- Je voulais remercier le plugin
class BaseController
  def render_xml(object, status: 200)
    [
      status,
      @headers.merge!({'Content-Type' => 'application/xml'}),
      [object.to_xml]
    ]
  end
end


