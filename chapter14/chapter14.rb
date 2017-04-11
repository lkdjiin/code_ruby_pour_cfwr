# --- Un DSL pour les routes
# Fichier routes.rb
get "/posts", route_to: "posts#index"
get "/posts/new", route_to: "posts#new"
get "/posts/show", route_to: "posts#show"
get "/posts/delete", route_to: "posts#delete"
post "/posts/new", route_to: "posts#create"
get "/posts/edit", route_to: "posts#edit"
post "/posts/edit", route_to: "posts#update"


# --- Pas grand changement dans la classe Application
# Fichier lib/application.rb
class Application
  def initialize
    @routes = Routes.new("./routes.rb")
  end
end


# --- Tout se passe dans la classe Routes
# Fichier lib/routes.rb
class Routes
  def initialize(file)
    @routes = {}
    eval File.read(file)
  end

  def get(path, route_to:)
    @routes[["get", path]] = Route.new(route_to)
  end

  def post(path, route_to:)
    @routes[["post", path]] = Route.new(route_to)
  end

  # ...
end


# ---
eval "[1, 2, 3].sum"
#=> 6
eval "foo"
#=> NameError: undefined local variable or method 'foo'


# --- Notre nouveau DSL
# Fichier routes.rb
Application.routes.config do

  get "/posts", route_to: "posts#index"
  get "/posts/new", route_to: "posts#new"
  get "/posts/show", route_to: "posts#show"
  get "/posts/delete", route_to: "posts#delete"
  post "/posts/new", route_to: "posts#create"
  get "/posts/edit", route_to: "posts#edit"
  post "/posts/edit", route_to: "posts#update"

end


# --- La classe Routes utilisant `instance_eval
class Routes
  def initialize
    @routes = {}
  end

  def config(&block)
    instance_eval &block
  end

  def get(path, route_to:)
    @routes[["get", path]] = Route.new(route_to)
  end

  def post(path, route_to:)
    @routes[["post", path]] = Route.new(route_to)
  end

  def find(verb, path)
    key = [verb.downcase, path.downcase.sub(%r{/$}, '')]
    @routes[key] or raise E404
  end
end


# --- Méthode de classe/variable de classe
class Application
  include Error

  def self.routes
    @@routes
  end

  def initialize
    @@routes = Routes.new
    require "./routes"
  end

  def call(env)
    route = @@routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    # ...
  end
end


# --- Exemple d'une variable de classe
class Counter
  @@class_counter = 0

  def initialize
    @@class_counter += 1
  end

  def self.total
    @@class_counter
  end

  def total
    @@class_counter
  end
end

# Au début nous n'avons encore aucun compteur.
Counter.total
#=> 0

c1 = Counter.new
# Après en avoir créer un premier le total passe logiquement à 1.
# Ce que nous confirme la méthode de classe.
Counter.total
#=> 1
# Ainsi que la méthode d'instance.
c1.total
#=> 1

# Nous créons un seconde compteur, le total passe donc à 2.
c2 = Counter.new
Counter.total
#=> 2
c2.total
#=> 2

# Ici le résultat pourrait vous perturber quelque peu. Il faut comprendre
# que nous utilisons une variable de classe, qui n'a donc rien à voir avec
# l'instance `c1`.
c1.total
#=> 2

