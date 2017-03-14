# --- On utilise le middleware Rack::Static
# Fichier config.ru
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
use Rack::Static, :urls => ["/css"], :root => "assets"
run Application.new

# --- On inclus les ressources commençant par /js
# Fichier config.ru
use Rack::Static, :urls => ["/css", "/js"], :root => "assets"


# --- On inclus les ressources commençant par /images
# Fichier config.ru
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"

# --- Une première étape
class Renderer
  private
  def include_css
    '<link rel="stylesheet" type="text/css" href="/css/main.css">'
  end
end

# --- Utilisation de IncludeCSS
class Renderer
  private
  def include_css
    IncludeCSS.call
  end
end

# --- Fabrication du code HTML
# Fichier lib/include_css.rb
class IncludeCSS
  def self.call
    files = YAML.load_file("assets/css/css.yml")
    files.map do |file|
      "<link rel='stylesheet' type='text/css' href='/css/#{file}'>\n"
    end.join
  end
end

# --- Ne pas oublier !
# Fichier lib/application.rb
require_relative 'include_css'

# --- Fabrication des tags pour les fichiers JavaScript
# Fichier lib/include_javascript.rb
class IncludeJavascript
  def self.call
    files = YAML.load_file("assets/js/js.yml")
    files.map do |file|
      "<script src='/js/#{file}'></script>"
    end.join
  end
end

# --- Utilisation de IncludeJavascript
class Renderer
  private
  def include_javascript
    IncludeJavascript.call
  end
end

# ---
# Fichier lib/application.rb
require_relative 'include_javascript'
