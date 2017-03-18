# --- Retournons le nécessaire à Rack
# Fichier lib/application.rb
class Application

  def initialize
    @routes = Routes.new(YAML.load_file("routes.yml"))
  end

  def call(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    req = Rack::Request.new(env)
    route.exec_with(req.params)
  rescue
    [500, {"Content-Type" => "text/html"}, [File.read("public/500.html")]]
  end
end

# --- Simulation d'un plantage dans notre application
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def new
    fail
    render "posts/new.html.erb"
  end
end


# --- On provoque l'erreur 404 au besoin
# Fichier lib/routes.rb
class Routes
  def find(verb, path)
    key = [verb.downcase, path.downcase.sub(%r{/$}, '')]
    @routes[key] or raise E404
  end
end

# ---
hash = {"a" => 1}
hash["a"]
#=> 1
hash["b"]
#=> nil

# ---
# 1
raise E404 unless @routes[key]
@routes[key]
# 2
if @routes[key]
  @routes[key]
else
  raise E404
end
# 3
@routes[key] ? @routes[key] : raise E404

# --- Création et utilisation de la classe E404
# Fichier lib/application.rb
E404 = Class.new(StandardError)

class Application

  def initialize
    @routes = Routes.new(YAML.load_file("routes.yml"))
  end

  def call(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    req = Rack::Request.new(env)
    route.exec_with(req.params)
  rescue E404 => ex
    [404, {"Content-Type" => "text/html"}, [File.read("public/404.html")]]
  rescue
    [500, {"Content-Type" => "text/html"}, [File.read("public/500.html")]]
  end
end

# ---
# 1
E404 = Class.new(StandardError)
# 2
class E404 < StandardError
end

# --- Un module dédié aux erreurs 404 et 500
# Fichier lib/error.rb
E404 = Class.new(StandardError)

module Error
  def error_404
    [404, {"Content-Type" => "text/html"}, [File.read("public/404.html")]]
  end

  def error_500
    [500, {"Content-Type" => "text/html"}, [File.read("public/500.html")]]
  end
end


# --- Utilisons le module Error
# Fichier lib/application.rb
# ...
require_relative 'error'
# ...
class Application
  include Error

  # ...

  def call(env)
    # ...
  rescue E404 => ex
    error_404
  rescue
    error_500
  end
end

# --- Erreur 404 si un post est introuvable
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def show
    if (@post = Post[params["id"]])
      render "posts/show.html.erb"
    else
      error_404
    end
  end
end

# --- Utilisons le module Error dans les contrôleurs
# Fichier lib/base_controller.rb
class BaseController
  include Error
end
