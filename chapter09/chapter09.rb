# --- Afficher le formulaire
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def new
    render "posts/new.html.erb"
  end
end

# --- Y a comme un problème
require_relative 'routes_builder'
require 'yaml'
builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
builder.build

# --- Le dernier arrivé à raison
{a: 1, a: 2, a: 3}
#=> { :a => 3 }

# --- Une classe pour représenter une route
# Fichier lib/route.rb
class Route

  def initialize(value)
    @controller, @method = value.split('#')
    @controller = @controller.capitalize + 'Controller'
  end

  attr_reader :controller, :method
end

# --- La nouvelle classe Application
require_relative 'route'
class Application

  def initialize
    # Simplifions !
    @routes = RoutesBuilder.new(YAML.load_file("routes.yml"))
  end

  def call(env)
    req = Rack::Request.new(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])

    exec(route, req.params)
  rescue
    fail("No matching routes")
  end

  private

  def exec(route, params)
    controller = Object.const_get(route.controller).new(params)
    controller.send(route.method)
  end
end

# --- La classe RoutesBuilder remaniée
class RoutesBuilder
  def initialize(routes_from_file)
    @routes = {}
    routes_from_file.each {|key, value| @routes[key] = Route.new(value) }
  end

  def find(verb, path)
    key = [verb.downcase, path.downcase]
    @routes[key]
  end
end

# --- Une méthode create temporaire, juste pour voir
class PostsController < BaseController
  def create
    p params
    [200, {}, ["ok"]]
  end
end

# --- La méthode create finale
class PostsController < BaseController
  def create
    Post.create(title: params["title"],
                content: params["content"],
                date: Time.now.to_i)
    redirect_to "/posts"
  end
end

# --- La méthode edit
class PostsController < BaseController
  def edit
    @post = Post[params["id"]]
    render "posts/edit.html.erb"
  end
end

# --- La méthode update
class PostsController < BaseController
  def update
    post = Post[params["id"]]
    post.update(title: params["title"], content: params["content"])
    redirect_to "/posts"
  end
end

# --- Suppression du slash final
class RoutesBuilder
  def find(verb, path)
    key = [verb.downcase, path.downcase.sub(%r{/$}, '')]
    @routes[key]
  end
end

# --- Il faut reflèter cette modif dans Application
# Fichier lib/application.rb
require_relative 'routes'
class Application
  def initialize
    @routes = Routes.new(YAML.load_file("routes.yml"))
  end
end

# --- Une route plus intelligente
class Route
  def initialize(value)
    @controller, @method = value.split('#')
    @controller = @controller.capitalize + 'Controller'
  end

  def exec_with(params)
    controller = Object.const_get(@controller).new(params)
    controller.send(@method)
  end
end

# --- Un dernier refactoring
class Application
  def initialize
    @routes = Routes.new(YAML.load_file("routes.yml"))
  end

  def call(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    req = Rack::Request.new(env)
    route.exec_with(req.params)
  rescue
    fail("No matching routes")
  end
end
