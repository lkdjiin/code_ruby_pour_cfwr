# ---
# Chargeons les 3 routes
require 'yaml'
# On charge tout.
routes = YAML.load_file("routes.yml")

# Est-ce que la route /hola est là ?
routes['/hola']
#=> {
#=>     "via" => "get",
#=>      "to" => "greetings#hola"
#=> }

# Et la racine ?
routes['/']
#=> {
#=>     "via" => "get",
#=>      "to" => "root#index"
#=> }

# ---
# Nos deux contrôleurs
# Fichier root_controller.rb
class RootController
  def index
    status, body = Renderer.new("root.html").render
    [status, {}, [body]]
  end
end

# Fichier greetings_controller.rb
class GreetingsController
  def hello
    status, body = Renderer.new("hello.html").render
    [status, {}, [body]]
  end

  def hola
    status, body = Renderer.new("hola.html").render
    [status, {}, [body]]
  end
end

# ---
# Voyez comme c'est facile !
to = "root#index"
controller, method = to.split('#')
puts controller
#=> root
puts method
#=> index

# ---
# Modifiez ces routes que je ne saurais prendre…
# Fichier routes_builder.rb
class RoutesBuilder
  attr_reader :routes

  def initialize(routes_from_file)
    @routes_from_file = routes_from_file
    @routes = {}
  end

  def build
    @routes_from_file.each { |key, value| @routes[key] = build_route(value) }
  end

  private

  def build_route(values)
    controller, method = values['to'].split('#')
    controller = controller.capitalize + 'Controller'
    { 'via' => values['via'], 'controller' => controller, 'method' => method }
  end
end

# ---
# Testons RoutesBuilder
require 'yaml'
require './routes_builder'
routes = YAML.load_file("routes.yml")
builder = RoutesBuilder.new(routes)
builder.build
builder.routes

# ---
# On utilise RoutesBuilder dans l'application
# Fichier application.rb
require 'yaml'
require_relative 'routes_builder'

class Application

  def initialize
    builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
    builder.build
    @routes = builder.routes
  end
end

# ---
# Il faut charger les constantes !
require_relative 'greetings_controller'

# ---
# Faisons tout ça avec classe
klass = Object.const_get("GreetingsController")

# ---
# Test dans irb
controller = klass.new
#=> #<GreetingsController:0x00563ef2efc130>

# ---
# Toujours dans irb
controller.send("hello")
#=> NameError: uninitialized constant GreetingsController::Renderer

# ---
# La classe Postman
class Postman
  def deliver(content = "Rien de neuf")
    puts "Le facteur vous remet un message : #{content}"
  end
end

# ---
# Usage classique
postman = Postman.new
postman.deliver
#=> Le facteur vous remet un message : Rien de neuf
postman.deliver("Rendez-vous au Jack Rabbit Slim's")
#=> Le facteur vous remet un message : Rendez-vous au Jack Rabbit Slim's

# ---
# En utilisant send
postman = Postman.new
postman.send(:deliver)
#=> Le facteur vous remet un message : Rien de neuf
postman.send(:deliver, "Rendez-vous au Jack Rabbit Slim's")
#=> Le facteur vous remet un message : Rendez-vous au Jack Rabbit Slim's

# ---
# C'est beau, hein ? C'est notre appli !
# Fichier application.rb
require 'yaml'
require_relative 'renderer'
require_relative 'routes_builder'
require_relative 'root_controller'
require_relative 'greetings_controller'

class Application

  def initialize
    builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
    builder.build
    @routes = builder.routes
  end

  def call(env)
    route = @routes[env['REQUEST_PATH']]

    if route
      controller = Object.const_get(route['controller']).new
      controller.send(route['method'])
    else
      fail "No matching routes"
    end
  end
end

# ---
# C'est encore mieux après un brin de ménage
# Fichier application.rb
require 'yaml'
require_relative 'renderer'
require_relative 'routes_builder'
require_relative 'root_controller'
require_relative 'greetings_controller'

class Application

  def initialize
    builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
    builder.build
    @routes = builder.routes
  end

  def call(env)
    exec @routes[env['REQUEST_PATH']]
  rescue
    fail("No matching routes")
  end

  private

  def exec(route)
    controller = Object.const_get(route['controller']).new
    controller.send(route['method'])
  end
end

# ---
# On charge les contrôleurs explicitement
# Fichier application.rb
require_relative 'root_controller'
require_relative 'greetings_controller'

# ---
Dir.glob('*.rb')

# ---
Dir.glob('controllers/*.rb') { |filename| require_relative(filename) }

# ---
# On charge tout les contrôleurs en une ligne
# Fichier application.rb
require 'yaml'
require_relative 'renderer'
require_relative 'routes_builder'

Dir.glob('controllers/*.rb') { |filename| require_relative(filename) }

# ---
# Pas bien. Moche. Lourd. Beurk
class RootController
  def index
    status, body = Renderer.new("root.html").render
    [status, {}, [body]]
  end
end

# ---
# Bien. Miam-miam. Léger
class RootController
  def index
    render "root.html"
  end
end

# ---
# Une classe de base pour les contrôleurs
# Fichier base_controller.rb
class BaseController

  private

  def render(filename)
    status, body = Renderer.new(filename).render
    [status, {}, [body]]
  end
end

# ---
# Nos contrôleurs réarrangés
# Fichier controllers/root_controller.rb
class RootController < BaseController
  def index
    render "root.html"
  end
end

# Fichier controllers/greetings_controller.rb
class GreetingsController < BaseController
  def hello
    render "hello.html"
  end

  def hola
    render "hola.html"
  end
end

# ---
# Fichier application.rb
require 'yaml'
require_relative 'renderer'
require_relative 'routes_builder'
require_relative 'base_controller'
# ...


# ---
# Je n'ai besoin de personne, en Harley…
# Fichier root_controller.rb
class RootController
  def index
    render "root.html"
  end

  private

  def render(filename)
    status, body = Renderer.new(filename).render
    [status, {}, [body]]
  end
end

# Fichier greetings_controller.rb
class GreetingsController
  def hello
    render "hello.html"
  end

  def hola
    render "hola.html"
  end

  private

  def render(filename)
    status, body = Renderer.new(filename).render
    [status, {}, [body]]
  end
end

# ---
# Les vues sont désormais dans le dossier views
# Fichier lib/base_controller.rb
class BaseController

  private

  def render(filename)
    status, body = Renderer.new(File.join('views', filename)).render
    [status, {}, [body]]
  end
end

# ---
# La toute dernière touche
# Fichier config.ru
require_relative 'lib/application'
run Application.new

# Fichier lib/application.rb
# [...]
Dir.glob('controllers/*.rb') { |filename| require_relative("../#{filename}") }
# [...]
