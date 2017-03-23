# --- Désactivez les erreurs 500
class Application
  def call(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    req = Rack::Request.new(env)
    route.exec_with(req.params)
  rescue E404 => ex
    error_404
  # rescue
  #   error_500
  end
end

# --- La méthode partial
# Fichier lib/base_controller.rb
def partial(filename)
  Renderer.new(File.join('views', filename), binding).render_partial
end

# --- La méthode render_partial
# Fichier lib/renderer.rb
class Renderer
  def render
    if File.exists?(@filename)
      [200, result]
    else
      no_template
    end
  end

  def render_partial
    if File.exists?(@filename)
      ERB.new(template).result(@binding)
    else
      no_template
    end
  end

  private

  def no_template
    puts "Erreur 500 Template inconnu: #{@filename}"
    fail
  end
end

# --- Un post «vide»
def new
  @post = Post.new
  render "posts/new.html.erb"
end

# --- La méthode include_partial
class Renderer
  def include_partial(filename)
    Renderer.new(File.join('views', filename), @binding).render_partial
  end
end

# --- La méthode content_for
class BaseController

  def render(filename)
    @binding = binding
    status, body = Renderer.new(File.join('views', filename), @binding).render
    [status, {}, [body]]
  end

  def content_for(name, value)
    @binding.local_variable_set(name, value)
  end
end

# --- La méthode include_content
class Renderer
  def include_content(name)
    @binding.local_variable_get(name)
  end
end

# --- Évitons les problèmes
class Renderer
  def include_content(name)
    @binding.local_variable_get(name)
  rescue
    nil
  end
end
