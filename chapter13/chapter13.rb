# --- Une 1ère version simple de notice?
class BaseController
  def notice?
    true
  end
end


# --- Pareil pour notice
class BaseController
  def notice
    "C'est à une demi-heure d'ici. J'y suis dans dix minutes."
  end
end


# --- Création de la notice dans le contrôleur
class PostsController < BaseController
  def create
    Post.create(title: params["title"],
                content: params["content"],
                date: Time.now.to_i)
    notice("Post créé avec succès")
    redirect_to "/posts"
  end
end


# --- Qu'est ce qu'on va mettre ici ?
class BaseController
  def notice(value = nil)
    if value
      ??
    else
      "C'est à une demi-heure d'ici. J'y suis dans dix minutes."
    end
  end
end


# --- Ajout d'un middleware Rack pour activer les cookies
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
run Application.new


# --- Utilisation de la classe Notice qui n'existe pas encore
# Fichier lib/application.rb
require_relative 'notice'
# [...]
class Application
  # [...]
  def call(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    notice = Notice.new(env["rack.session"])
    req = Rack::Request.new(env)
    route.exec_with(req.params, notice)
    # [...]
  end
end


# --- La classe Notice, enfin !
# Fichier lib/notice.rb
class Notice
  def initialize(session)
    @session = session
    if @session['notice']
      @value = @session['notice']
      @session.delete('notice')
    else
      @value = nil
    end
  end

  def value=(content)
    @value = content
    @session.store('notice', content)
  end

  def value
    @value
  end
end


# --- Application donne à Route, qui passe à Controller
class Route
  def initialize(value)
    @controller, @method = value.split('#')
    @controller = @controller.capitalize + 'Controller'
  end

  def exec_with(params, notice)
    controller = Object.const_get(@controller).new(params, notice)
    controller.send(@method)
  end
end


# --- Les références à Notice dans BaseController
class BaseController
  include Error

  def initialize(params, notice)
    @params = params
    @notice = notice
  end

  private

  def notice?
    @notice.value
  end

  def notice(value = nil)
    if value
      @notice.value = value
    else
      @notice.value
    end
  end
end
