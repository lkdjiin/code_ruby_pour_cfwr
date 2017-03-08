# --- Une base de données pour notre blog
require 'sqlite3'
db = SQLite3::Database.new("db/database.sqlite")
sql = "CREATE TABLE posts(id INTEGER PRIMARY KEY, title TEXT, content TEXT, \
       date INTEGER);"
db.execute(sql)

sql = "INSERT INTO posts(title, content, date) VALUES(?, ?, ?);"
time = Time.now.to_i

title = "Bonjour"
content = "Bonjour le monde !\nComment ça va ?"
db.execute(sql, [title, content, time])

title = "Et ça continue"
content = "Voici le second post du blog."
db.execute(sql, [title, content, time + 200_000])

# --- Un modèle Post
# Fichier models/post.rb
class Post < Sequel::Model
end

# --- Un contrôleur pour les posts
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def index
    @posts = Post.all
    render "posts/index.html.erb"
  end
end

# --- Utilisons plutôt PATH_INFO
# Fichier lib/application.rb
class Application
  def call(env)
    exec @routes[env['PATH_INFO']]
  rescue
    fail("No matching routes")
  end
end

# --- Utilisons Rack::Request
# Fichier lib/application.rb
class Application
  def call(env)
    req = Rack::Request.new(env)
    return [200, {}, [req.params.to_s]]
    exec @routes[env['PATH_INFO']]
  rescue
    fail("No matching routes")
  end
end

# --- La méthode show
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def show
    @post = Post[params["id"]]
    render "posts/show.html.erb"
  end
end

# -- La méthode params
# Fichier lib/base_controller.rb
class BaseController

  def initialize(params)
    @params = params
  end

  private

  attr_reader :params

  def render(filename)
    status, body = Renderer.new(File.join('views', filename), binding).render
    [status, {}, [body]]
  end
end

# --- Les contrôleurs ont besoin des paramêtres de la query string
# Fichier lib/application.rb
class Application

  def initialize
    builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
    builder.build
    @routes = builder.routes
  end

  def call(env)
    exec(@routes[env['PATH_INFO']], env)
  rescue
    fail("No matching routes")
  end

  private

  def exec(route, env)
    req = Rack::Request.new(env)
    controller = Object.const_get(route['controller']).new(req.params)
    controller.send(route['method'])
  end
end

# --- Supprimons et puis… et puis quoi, au fait ?
class PostsController < BaseController
  def delete
    # Supprimer, d'accord.
    post = Post[params["id"]]
    post.delete

    # Mais après, on affiche quoi ?
    render ??
  end
end

# --- Marche pas
class PostsController < BaseController
  def delete
    post = Post[params["id"]]
    post.delete

    render "posts/index.html.erb"
  end
end

# --- Trop de redondance
class PostsController < BaseController
  def delete
    post = Post[params["id"]]
    post.delete

    @posts = Post.all
    render "posts/index.html.erb"
  end
end

# --- Ça marche mais…
class PostsController < BaseController
  def delete
    post = Post[params["id"]]
    post.delete
    index
  end
end

# --- On a besoin d'une redirection
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def delete
    post = Post[params["id"]]
    post.delete
    redirect_to "/posts/index"
  end
end

# --- La méthode redirect_to
# Fichier lib/base_controller.rb
class BaseController

  private

  def redirect_to(path)
    [303, {'Location' => path}, ['303 See Other']]
  end
end
