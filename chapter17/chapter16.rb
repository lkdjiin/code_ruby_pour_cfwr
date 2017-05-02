# --- Fichier Ruby contenant la migration
# Fichier db/migrations/01_create_posts.rb
Sequel.migration do
  change do
    create_table(:posts) do
      primary_key :id
      String :title, :text=>true
      String :content, :text=>true
      DateTime :date
    end
  end
end

# --- Une seconde migration
# Fichier db/migrations/02_add_gif_to_posts.rb
Sequel.migration do
  change do
    add_column :posts, :gif, String, :text=>true
  end
end

# --- On utilise le module ERB::Util
# Fichier lib/base_controller.rb
class BaseController
  # ...
  include ERB::Util
  # ...
end

# --- On sauvegarde le GIF dans le contrôleur
class PostsController < BaseController
  def create
    Post.create(title: params["title"],
                content: params["content"],
                gif: params["gif"],
                date: Time.now)
    notice("Post créé avec succès")
    redirect_to "/posts"
  end

  def update
    post = Post[params["id"]]
    post.update(title: params["title"],
                content: params["content"],
                gif: params["gif"])
    redirect_to "/posts"
  end
end

# --- Une tâche Rake pour migrer
# Fichier Rakefile
namespace :db do
  desc "Run migrations"
  task :migrate do |t|
    puts "Migrating…"
    require "sequel"
    Sequel.extension :migration
    connexion = ENV["DATABASE_URL"] || File.read("db/configuration").chomp
    db = Sequel.connect(connexion)
    Sequel::Migrator.run(db, "db/migrations")
    puts "Done."
  end
end
