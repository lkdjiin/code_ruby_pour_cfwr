# ---
# Charger le fichier routes.yml avec Ruby
require 'yaml'
YAML.load_file("routes.yml")
#=> {
#=>     "/hello" => {
#=>         "via" => "get",
#=>          "to" => "hello#index"
#=>     }
#=> }

# ---
# En route pour une nouvelle application
# Fichier application.rb
require 'yaml'

class Application
  def initialize
    @routes = YAML.load_file("routes.yml")
  end
end

# ---
# Voir l'objet au sein d'une session irb
require "./application"
Application.new

# ---
# Afficher un membre
require "./application"
app = Application.new
app.instance_variable_get("@routes")
#=> {"/hello" => {"via" => "get", "to" => "hello#index"}}

# ---
# On ajoute le call qui va bien
# Fichier application.rb
require 'yaml'

class Application

  def initialize
    @routes = YAML.load_file("routes.yml")
  end

  def call(env)
    if @routes[env["REQUEST_PATH"]]
      [200, {}, ["Ce chemin existe"]]
    else
      [200, {}, ["Ce chemin n'existe pas"]]
    end
  end
end

# ---
# En avant !
# Fichier config.ru
require_relative "application"
run Application.new

# ---
# Un contrôleur minimal, mais alors vraiment minimal
# Fichier hello_controller.rb
class HelloController
  def index
    [200, {}, ["Coucou !"]]
  end
end

# ---
# Utilisons ce fameux contrôleur
# Fichier application.rb
require 'yaml'
require_relative 'hello_controller'

class Application

  def initialize
    @routes = YAML.load_file("routes.yml")
  end

  def call(env)
    if route_exists?(env["REQUEST_PATH"])
      HelloController.new.index
    else
      fail "Pas de route correspondante"
    end
  end

  private

  def route_exists?(path)
    @routes[path]
  end
end

# ---
# Lire la vue avec File.read
# Fichier hello_controller.rb
class HelloController
  def index
    [200, {}, [File.read("hello.html")]]
  end
end

# ---
# Utilisons une classe pour faire le rendu
# Fichier hello_controller.rb
class HelloController
  def index
    status, body = Renderer.new("hello.html").render
    [status, {}, [body]]
  end
end

# Fichier renderer.rb
class Renderer
  def initialize(filename)
    @filename = filename
  end

  def render
    if File.exists?(@filename)
      [200, File.read(@filename)]
    else
      [500, "<h1>500</h1><p>No such template: #{@filename}</p>"]
    end
  end
end

# ---
# Testons la classe Renderer dans irb
require "./renderer"
Renderer.new("hello.html").render
#=> [
#=>   200,
#=>   "<h1>Hello from an amazing web application!</h1>\n"
#=> ]
Renderer.new("unknown").render
#=> [
#=>   500,
#=>   "<h1>500</h1><p>No such template: unknown</p>"
#=> ]
