# --- La nouvelle chaîne de connexion
# Fichier lib/application.rb
DB = Sequel.connect("postgres://framework:password@localhost:5432/framework_blog")


# --- Un dernier changement
# Fichier controllers/post_controller.rb
class PostsController < BaseController
  def create
    Post.create(title: params["title"],
                content: params["content"],
                date: Time.now) # <------------------------------
    notice("Post créé avec succès")
    redirect_to "/posts"
  end
end


# --- Vers un framework flexible
# Fichier lib/application.rb
DB = Sequel.connect(File.read("db/configuration").chomp)
