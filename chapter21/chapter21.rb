# --- haml dans le Gemfile
source "https://rubygems.org/"

ruby "~> 2.4.0"

gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sequel', '~> 4.43.0'
gem 'pg'
gem 'haml'


# --- Informer le contrôleur
class PostsController < BaseController
  def index
    @posts = Post.all
    render "posts/index.html.haml"
  end
end


# --- Utilisation du moteur HAML
class Renderer
  def result
    if @filename.end_with?(".erb")
      content = ERB.new(template).result(@binding)
    else
      content = Haml::Engine.new(template).render(@binding)
    end
    insert_in_main_template { content }
  end
end


# --- Comparaison
ERB.new(template).result(@binding)
Haml::Engine.new(template).render(@binding)


# --- markaby dans le Gemfile
source "https://rubygems.org/"

ruby "~> 2.4.0"

gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sequel', '~> 4.43.0'
gem 'pg'
gem 'markaby', '0.8.0'


# --- La vue au «format» Markaby
# Fichier views/posts/show.rb
module Views
  def self.render(binding)
    post = binding.eval("@post")
    markaby = Markaby::Builder.new

    template(markaby, post).to_s
  end

  def self.template(markaby, post)
    markaby.div do
      h2 post.title
      div { i Time.at(post.date) }
      p post.content
      div post.gif
      p do
        a "Supprimer (mais ne venez pas pleurer après !)",
          :href => "/posts/delete?id=#{post.id}"
      end
    end
  end
end


# --- Markaby dans le contrôleur
# Fichier controllers/post_controller.rb
class PostsController < BaseController
  def show
    if (@post = Post[params["id"]])
      render "posts/show.rb"
    else
      error_404
    end
  end
end


# --- Chargement et rendu du «template» Markaby
# Fichier lib/renderer.rb
class Renderer
  def result
    if @filename.end_with?(".erb")
      content = ERB.new(template).result(@binding)
    else
      load @filename
      content = Views.render(@binding)
    end
    insert_in_main_template { content }
  end
end


# --- liquid dans le Gemfile
source "https://rubygems.org/"

ruby "~> 2.4.0"

gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sequel', '~> 4.43.0'
gem 'pg'
gem 'liquid', '4.0.0'


# --- Le presenter
# Fichier models/post_presenter.rb
class PostPresenter
  def initialize(post)
    @post = post
  end

  def show
    {
      "title" => @post.title,
      "date" => Time.at(@post.date),
      "content" => @post.content,
      "gif" => @post.gif,
      "id" => @post.id
    }
  end
end


# --- La nouvelle méthode show
# Fichier controllers/post_controller.rb
class PostsController < BaseController
  def show
    if (@post = Post[params["id"]])
      render "posts/show.html.liquid", args: PostPresenter.new(@post).show
    else
      error_404
    end
  end
end


# --- La nouvelle méthode render
# Fichier lib/base_controller.rb
class BaseController
  def render(filename, args: {})
    @binding = binding
    status, body =
      Renderer.new(File.join('views', filename), @binding, args).render
    [status, @headers, [body]]
  end
end


# --- La nouvelle classe Renderer
# Fichier lib/renderer.rb
class Renderer
  def initialize(filename, binding, args = {})
    @filename = filename
    @binding = binding
    @args = args
  end

  # ...

  def result
    insert_in_main_template do
      if @filename.end_with?(".erb")
        ERB.new(template).result(@binding)
      else
        Liquid::Template.parse(template).render(@args)
      end
    end
  end
end
