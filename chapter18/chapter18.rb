# --- Afficher le chemin
# Fichier config.ru
class Application
  def call(env)
    [200, {}, [env["PATH_INFO"]]]
  end
end
run Application.new


# --- Afficher le chemin en majuscules
class Application
  def call(env)
    [200, {}, [env["PATH_INFO"].upcase]]
  end
end


# --- Structure d'un middleware
class Middleware
  def initialize(app)
  end

  def call(env)
  end
end


# --- Un middleware minimal
class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  end
end


# --- Un middleware pour transformer le chemin
class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env["PATH_INFO"].upcase!
    @app.call(env)
  end
end


# --- Comment utiliser les middlewares
use Middleware1
use Middleware2
use Middleware3
run Application.new


# --- Le fichier complet
# Fichier config.ru
class Application
  def call(env)
    [200, {}, [env["PATH_INFO"]]]
  end
end

class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env["PATH_INFO"].upcase!
    @app.call(env)
  end
end

use Middleware
run Application.new


# --- L'ancienne méthode find
class Routes
  def find(verb, path)
    key = [verb.downcase, path.downcase.sub(%r{/$}, '')]
    @routes[key] or raise E404
  end
end


# --- La nouvelle méthode find
# Fichier lib/routes.rb
class Routes
  def find(verb, path)
    key = [verb.downcase, path.downcase]
    @routes[key] or raise E404
  end
end


# --- Un middleware pour supprimer le slash final
# Fichier lib/middlewares/trailing_slash_remover.rb
class TrailingSlashRemover
  def initialize(app)
    @app = app
  end

  def call(env)
    env["PATH_INFO"] = env["PATH_INFO"].sub(%r{/$}, '')
    @app.call(env)
  end
end


# --- Utilisation du middleware
# Fichier config.ru
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'

use TrailingSlashRemover
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"

run Application.new


# --- La logique du nouveau middleware
class PublicTxt
  def initialize(app)
    @app = app
  end

  def call(env)
    @file = env["PATH_INFO"]

    if public_txt_file?
      [200, headers, [content]]
    else
      @app.call(env)
    end
  end
end


# --- Le middleware PublicTxt complet
class PublicTxt
  def initialize(app)
    @app = app
  end

  def call(env)
    @file = env["PATH_INFO"]

    if public_txt_file?
      [200, headers, [content]]
    else
      @app.call(env)
    end
  end

  private

  def public_txt_file?
    @file.start_with?("/") &&
      @file.count("/") == 1 &&
      @file.end_with?(".txt") &&
      File.exist?(real_file)
  end

  def real_file
    "public" + @file
  end

  def content
    @content ||= File.read(real_file)
  end

  def length
    content.size.to_s
  end

  def headers
    {"Content-Type" => "text/plain", "Content-Length" => length}
  end
end


# --- Insertion du middleware PublicTxt
# Fichier config.ru
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'
require_relative 'lib/middlewares/public_txt'

use PublicTxt
use TrailingSlashRemover
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"

run Application.new


# --- Le constructeur peut prendre autre chose que app
class PublicTxt
  def initialize(app, folder: "public")
    @app = app
    @folder = folder
  end

  private

  def real_file
    @folder + @file
  end
end


# --- Insertion d'un middleware avec argument
use PublicTxt, folder: "fichiers_html"


# --- API ou navigateur ?
class Application
  def call(env)
    if env["framework.api"]
      execute_api_request(env)
    else
      execute_browser_request(env)
    end
  end
end


# --- Middleware APISwitcher
class APISwitcher
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ %r{\A/v\d+/}
      env.store("framework.api", true)
    end

    @app.call(env)
  end
end


# --- La classe Application pour tester APISwitcher
class Application
  def call(env)
    if env["framework.api"]
      execute_api_request(env)
    else
      execute_browser_request(env)
    end
  end

  private

  def execute_api_request(env)
    [200, {}, ["API response for #{env["PATH_INFO"]}"]]
  end

  def execute_browser_request(env)
    route = @@routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    notice = Notice.new(env["rack.session"])
    req = Rack::Request.new(env)
    route.exec_with(req.params, notice)
  rescue E404 => ex
    error_404
  rescue
    error_500
  end
end


# --- Insertion de APISwitcher
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'
require_relative 'lib/middlewares/public_txt'
require_relative 'lib/middlewares/api_switcher'

use PublicTxt
use TrailingSlashRemover
use APISwitcher
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"

run Application.new


# --- Pattern général
def call(env)
  # 1
  do_before_app

  # 2
  status, headers, body = @app.call(env)

  # 3
  do_after_app

  # 4
  [status, headers, body]
end


# --- Le middleware NoticeBuilder
# Fichier lib/middlewares/notice_builder.rb
class NoticeBuilder

  SESSION = "rack.session"
  FRAMEWORK_NOTICE = "framework.notice"
  NOTICE = "notice"

  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env

    set_framework_notice

    status, headers, body = @app.call(@env)

    set_session_notice

    [status, headers, body]
  end

  private

  def set_framework_notice
    @env.store(FRAMEWORK_NOTICE, @env[SESSION].delete(NOTICE))
  end

  def set_session_notice
    @env[SESSION].store(NOTICE, @env[FRAMEWORK_NOTICE]) if framework_notice?
  end

  def framework_notice?
    @env[FRAMEWORK_NOTICE]
  end
end


# --- La nouvelle classe Notice bien plus simple
# Fichier lib/notice.rb
class Notice
  KEY = "framework.notice"

  def initialize(env)
    @env = env
    @value = @env.delete(KEY)
  end

  def value=(v)
    @env.store(KEY, v)
  end

  attr_reader :value
end


# --- Insertion de NoticeBuilder après Rack::Session
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'
require_relative 'lib/middlewares/public_txt'
require_relative 'lib/middlewares/api_switcher'
require_relative 'lib/middlewares/notice_builder'

use PublicTxt
use TrailingSlashRemover
use APISwitcher
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
use NoticeBuilder

run Application.new
