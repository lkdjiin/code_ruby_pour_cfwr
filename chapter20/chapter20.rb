# --- Des logs pour Rack
require 'logger'
use Rack::CommonLogger, Logger.new('logs/rack.log')


# --- Le nouveau config.ru
# Fichier config.ru

# leanpub-start-insert
require 'logger'
# leanpub-end-insert
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'
require_relative 'lib/middlewares/public_txt'
require_relative 'lib/middlewares/api_switcher'
require_relative 'lib/middlewares/notice_builder'
require_relative 'lib/middlewares/browser_cache'

# leanpub-start-insert
use Rack::CommonLogger, Logger.new('logs/rack.log')
# leanpub-end-insert
use TrailingSlashRemover
use PublicTxt
use APISwitcher
use BrowserCache
use Rack::ConditionalGet
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
use NoticeBuilder

run Application.new


# --- Avant
# Fichier lib/application.rb
DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration").chomp)


# --- Après
# Fichier lib/application.rb
DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration").chomp,
                    logger: Logger.new("logs/db.log"))


# --- FrameworkLogger
# Fichier lib/framework_logger.rb
class FrameworkLogger
  include Singleton

  attr_accessor :logger
end


# --- Le nouveau constructeur
# Fichier lib/application.rb
require 'singleton'
require_relative 'framework_logger'

class Application
  def initialize(logger:)
    @@routes = Routes.new
    require "./routes"
    FrameworkLogger.instance.logger = logger
  end
end


# --- Création du logger personnalisé
# Fichier config.ru
# ...
run Application.new(logger: Logger.new("logs/app.log"))


# --- Exemple d'utilisation
FrameworkLogger.instance.logger.info "Ceci est une info"


# --- Utilisation dans les contrôleurs
class PostsController < BaseController
  def index
    FrameworkLogger.instance.logger.info "Accueil vu"

    @posts = Post.all
    headers "Cache-Control" => "private,max-age=30"
    render "posts/index.html.erb"
  end

  def show
    if (@post = Post[params["id"]])
      FrameworkLogger.instance.logger.info "Post n° #{params["id"]} vu"
      render "posts/show.html.erb"
    else
      error_404
    end
  end
end


# --- FrameworkLogger amélioré
class FrameworkLogger
  include Singleton

  attr_accessor :logger

  def self.info(message)
    instance.logger.info(message)
  end
end


# --- Un nouvel exemple
FrameworkLogger.info "Ceci est une info"


# --- FrameworkLogger avec toutes les méthodes «helper»
class FrameworkLogger
  include Singleton

  attr_accessor :logger

  def self.info(message)
    instance.logger.info(message)
  end

  def self.debug(message)
    instance.logger.debug(message)
  end

  def self.warn(message)
    instance.logger.warn(message)
  end

  def self.error(message)
    instance.logger.error(message)
  end

  def self.fatal(message)
    instance.logger.fatal(message)
  end
end


# --- FrameworkLogger avec meta programmation
class FrameworkLogger
  include Singleton

  attr_accessor :logger

  %i( info debug warn error fatal ).each do |name|
    define_singleton_method(name) do |message|
      instance.logger.send(name, message)
    end
  end
end


# --- Le module Logging
# Fichier lib/logging.rb
module Logging
  def info(message)
    FrameworkLogger.info(message)
  end
end


# --- Incorporation du module Logging
# Fichier lib/base_controller.rb
class BaseController
  include Logging
end

# Fichier lib/application.rb
require_relative 'logging'


# --- Une interface épurée
info "Ceci est une info"
