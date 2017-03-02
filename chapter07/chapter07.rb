# ---
# Un moteur de template hypothétique
template = "Bonjour <<nom>, vous êtes trop <<adjectif>>"
Engine.process(template, {nom: "Fonzy", adjectif: "cool"})
#=> "Bonjour Fonzy, vous êtes trop cool"
Engine.process(template, {nom: "Butch", adjectif: "fort"})
#=> "Bonjour Butch, vous êtes trop fort"

# ---
# Notre objectif
class ArticlesController < BaseController
  def index
    xxx = Article.all
    render "index.xxx"
  end
end

# ---
# Le moteur de template ERB
# ERB fait partie de la bibliothèque standard Ruby.
require 'erb'
# ERB remplacera ce qui se trouve entre `<%=` et `%>`.
template = 'Bonjour <%= data[:nom] %>, vous êtes trop <%= data[:adj] %>'
# Je vais revenir plus tard sur l'utilisation de `binding`.
data = {nom: "Fonzy", adj: "cool"}
ERB.new(template).result(binding)
#=> "Bonjour Fonzy, vous êtes trop cool"
data = {nom: "Butch", adj: "fort"}
ERB.new(template).result(binding)
#=> "Bonjour Butch, vous êtes trop fort"

# ---
class JulesWinnfield
  def initialize
    @food = "cheeseburger"
    @mate = "Vincent"
  end

  def get_binding
    local_var = "Meilleur second rôle"
    binding
  end
end

# ---
jules = JulesWinnfield.new
all_about_jules = jules.get_binding

all_about_jules.eval("@food")
#=> "cheeseburger"
all_about_jules.eval("@mate")
#=> "Vincent"

# ---
jules.instance_variable_set("@mate", "Fonzy")
all_about_jules.eval("@mate")
#=> "Fonzy"

# ---
jules.instance_variable_set("@obsession", "Ézéchiel")
all_about_jules.eval("@obsession")
#=> "Ézéchiel"

# ---
all_about_jules.eval("@obsession = 'Money'")
jules.instance_variable_get("@obsession")
#=> "Money"

# ---
all_about_jules.local_variables
all_about_jules.local_variable_get :local_var

# ---
def jules.say
  "Say what again!"
end

jules.say
#=> "Say what again!"

all_about_jules.eval("say")
#=> "Say what again!"

# ---
# Insérer chaque élément d'une collection
require "erb"
template = "<% @musics.each do |m| %> <%= m %> <% end %>"
@musics = %w( pop soul surf rock )
ERB.new(template).result(binding)
#=> " pop  soul  surf  rock "

# ---
# N'oublions pas ERB
# Fichier lib/application.rb
require 'erb'

# ---
# Utilisons ce qu'on a pris sur ERB
# Fichier lib/renderer.rb
class Renderer
  def initialize(filename, binding)
    @filename = filename
    @binding = binding
  end

  def render
    if File.exists?(@filename)
      template = File.read(@filename)
      [200, ERB.new(template).result(@binding)]
    else
      [500, "<h1>500</h1><p>No such template: #{@filename}</p>"]
    end
  end
end

# ---
# Le binding ! Le binding !
# Fichier lib/base_controller.rb
class BaseController

  private

  def render(filename)
    status, body = Renderer.new(File.join('views', filename), binding).render
    [status, {}, [body]]
  end
end

# ---
# Refactoring de Renderer
class Renderer
  def initialize(filename, binding)
    @filename = filename
    @binding = binding
  end

  def render
    if File.exists?(@filename)
      [200, result]
    else
      [500, no_template]
    end
  end

  private

  def result
    ERB.new(template).result(@binding)
  end

  def template
    File.read(@filename)
  end

  def no_template
    "<h1>500</h1><p>No such template: #{@filename}</p>"
  end
end

# ---
class ArticlesController < BaseController
  def index
    @articles = Article.all
    render "articles/index.html.erb"
  end
end

# ---
def actress(&block)
  puts "Uma"
  yield
  puts "Amanda"
end

# ---
actress { puts "Rosanna" }
#=> Uma
#=> Rosanna
#=> Amanda

# ---
actress do
  puts "Rosanna"
end
#=> Uma
#=> Rosanna
#=> Amanda

# ---
# La nouvelle classe Renderer
# Fichier lib/renderer.rb
class Renderer
  def initialize(filename, binding)
    @filename = filename
    @binding = binding
  end

  def render
    if File.exists?(@filename)
      [200, result]
    else
      [500, no_template]
    end
  end

  private

  def result
    content = ERB.new(template).result(@binding)
    insert_in_main_template { content }
  end

  def template
    File.read(@filename)
  end

  def insert_in_main_template
    ERB.new(main_template).result(binding)
  end

  def main_template
    File.read('views/layouts/application.html.erb')
  end

  def no_template
    "<h1>500</h1><p>Template inconnu: #{@filename}</p>"
  end
end

# ---
def result
  content = ERB.new(template).result(@binding)
  insert_in_main_template { content }
end

# ---
# new ne prend pas en compte les blocs. Le code qui suit ne fonctionne pas.
ERB.new(main_template) do
  content
end.result(binding)
# result non plus ne prend pas en compte les blocs. Le code suivant ne
# fonctionne donc pas non plus.
ERB.new(main_template).result(binding) do
 content
end

# ---
def actor
  yield
end
actor { "I'm John" }
#=> "I'm John"
actor { "I'm Bruce" }
#=> "I'm Bruce"

# ---
def insert_in_main_template
  ERB.new(main_template).result(binding)
end

def main_template
  File.read('views/layouts/application.html.erb')
end


