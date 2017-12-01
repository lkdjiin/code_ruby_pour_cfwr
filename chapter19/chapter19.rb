# --- Le middleware BrowserCache
# Fichier lib/middleware/browser_cache.rb
class BrowserCache
  def initialize(app, seconds: 60)
    @app = app
    @seconds = seconds
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers.merge!({"Cache-Control" => "private,max-age=#{@seconds}"})
    [status, headers, body]
  end
end


# --- Utilisation du middleware avec la valeur par défaut
use BrowserCache


# --- Utilisation du middleware avec une valeur personnalisée
use BrowserCache, seconds: 3600


# --- Le fichier config.ru avec le BrowserCache
# Fichier config.ru
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'
require_relative 'lib/middlewares/public_txt'
require_relative 'lib/middlewares/api_switcher'
require_relative 'lib/middlewares/notice_builder'
require_relative 'lib/middlewares/browser_cache'

use TrailingSlashRemover
use PublicTxt
use APISwitcher
use BrowserCache
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
use NoticeBuilder

run Application.new


# --- Un cache de 30 secondes pour tout le monde
# Fichier controllers/posts_controller.rb
class PostsController < BaseController
  def index
    @posts = Post.all
    headers "Cache-Control" => "private,max-age=30"
    render "posts/index.html.erb"
  end
end


# --- La méthode headers
# Fichier lib/base_controller.rb
class BaseController
  def initialize(params, notice)
    @params = params
    @notice = notice
    @headers = {}
  end

  private

  def render(filename)
    @binding = binding
    status, body = Renderer.new(File.join('views', filename), @binding).render
    [status, @headers, [body]]
  end

  def headers(hash)
    @headers.merge!(hash)
  end
end


# --- Le middleware BrowserCache final
# Fichier lib/middleware/browser_cache.rb
class BrowserCache
  def initialize(app, seconds: 60)
    @app = app
    @seconds = seconds
  end

  def call(env)
    status, headers, body = @app.call(env)

    unless headers["Cache-Control"]
      headers.merge!({"Cache-Control" => "private,max-age=#@seconds"})
    end

    [status, headers, body]
  end
end

