# --- Ajout du middleware
# Fichier config.ru
use Rack::Reloader


# --- Un contrôleur pour tester le rechargement automatique
# Fichier controllers/test_controller.rb
class TestController < BaseController
  def show
    render_json({ message: "OK"})
  end
end


# --- Une route pour tester
# Fichier routes.rb
Application.routes.config do
  get "/v1/test", route_to: "test#show"
end


# --- Changement du message
# Fichier controllers/test_controller.rb
class TestController < BaseController
  def test
    render_json({ message: "Et voici le rechargement auto…"})
  end
end


# --- Un middleware sous condition
# Fichier config.ru
if ENV["RACK_ENV"] == "development"
  use Rack::Reloader
end


# --- Le nouveau config.ru
# Fichier config.ru
require 'logger'
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
Dir.glob('lib/middlewares/*.rb') { |filename| require_relative("#{filename}") }

if ENV["RACK_ENV"] == "development"
  use Rack::Reloader
end

use Rack::CommonLogger, Logger.new("logs/rack.log")
use TrailingSlashRemover
use PublicTxt
use APISwitcher
use BrowserCache
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
use NoticeBuilder

run Application.new(logger: Logger.new("logs/app.log"))


# --- Nouveaux noms pour les logs
# Fichier config.ru
use Rack::CommonLogger, Logger.new("logs/rack_#{ENV["RACK_ENV"]}.log")
run Application.new(logger: Logger.new("logs/app_#{ENV["RACK_ENV"]}.log"))
# Fichier lib/application.rb
DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration").chomp,
                    logger: Logger.new("logs/db_#{ENV["RACK_ENV"]}.log"))



# --- Une db différente par environnement
# Fichier lib/application.rb
DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration_#{ENV["RACK_ENV"]}").chomp,
                    logger: Logger.new("logs/db_#{ENV["RACK_ENV"]}.log"))


# --- Un application.rb plus lisible
# Fichier lib/application.rb
require_relative 'database'
DB = Database.setup


# --- La classe Database
# Fichier lib/database.rb
class Database
  def self.setup
    new.setup
  end

  def setup
    Sequel.connect(connection_string, logger: log_file).tap do
      Sequel::Model.plugin :json_serializer
    end
  end

  private

  def connection_string
    ENV["DATABASE_URL"] ||
      File.read("db/configuration_#{ENV["RACK_ENV"]}").chomp
  end

  def log_file
    Logger.new("logs/db_#{ENV["RACK_ENV"]}.log")
  end
end


# --- Contrôleur
# Fichier controllers/hello_controller.rb
class HelloController < BaseController
  def index
    render "hello/index.html.erb"
  end
end


# --- Et route
# Fichier routes.rb 
Application.routes.config do
  get "/hello", route_to: "hello#index"
end


# --- Servons le fichier full.css
# Fichier lib/include_css.rb
class IncludeCSS
  def self.call
    if File.exists?("assets/css/full.css")
      single_serve
    else
      multiple_serve
    end
  end

  private

  def self.single_serve
    "<link rel='stylesheet' type='text/css' href='/css/full.css'>\n"
  end

  def self.multiple_serve
    files = YAML.load_file("assets/css/css.yml")
    files.map do |file|
      "<link rel='stylesheet' type='text/css' href='/css/#{file}'>\n"
    end.join
  end
end


# --- La nouvelle version de IncludeCSS
# Fichier lib/include_css.rb
class IncludeCSS
  def self.call
    if ENV["RACK_ENV"] == "production"
      single_serve
    else
      multiple_serve
    end
  end

  private

  def self.single_serve
    full_build unless File.exists?("assets/css/full.css")
    "<link rel='stylesheet' type='text/css' href='/css/full.css'>\n"
  end

  def self.multiple_serve
    files = YAML.load_file("assets/css/css.yml")
    files.map do |file|
      "<link rel='stylesheet' type='text/css' href='/css/#{file}'>\n"
    end.join
  end

  def self.full_build
    files = YAML.load_file("assets/css/css.yml")
    full = files.map { |file| File.read("assets/css/#{file}") }.join
    File.write('assets/css/full.css', full)
  end
end


# --- En fait la véritable nouvelle version c'est celle là
class IncludeCSS
  def self.call
    new.call
  end

  def initialize
    @names = {
      full: 'assets/css/full.css',
      yaml: 'assets/css/css.yml',
    }
  end

  def call
    production? ? single_serve : multiple_serve
  end

  private

  attr_reader :names

  def production?
    ENV["RACK_ENV"] == "production"
  end

  def single_serve
    full_build
    "<link rel='stylesheet' type='text/css' href='/css/full.css'>\n"
  end

  public def full_build
    return if full_css_present?

    File.write(names[:full], full_content)
  end

  def full_css_present?
    File.exists?(names[:full])
  end

  def full_content
    css_files.map { |file| File.read("assets/css/#{file}") }.join
  end

  def css_files
    YAML.load_file(names[:yaml])
  end

  def multiple_serve
    css_files.map do |file|
      "<link rel='stylesheet' type='text/css' href='/css/#{file}'>\n"
    end.join
  end
end


# --- rake css:compile
# Fichier Rakefile
namespace :css do
  desc "Build full.css"
  task :compile do |t|
    require_relative "lib/application"
    puts "Building `full.css`…"
    IncludeCSS.new.full_build
    puts "Done."
  end
end


# --- On retire d'un coté pour ajouter de l'autre
# Fichier lib/application.rb
require 'logger'
require 'bundler/setup'
Bundler.require(:default)


# --- Il était temps…
# Fichier Gemfile
gem 'rake'


# --- Nouveau Gemfile
source "https://rubygems.org/"

ruby "~> 2.4.0"

gem 'rake'
gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sequel', '~> 4.43.0'
gem 'sqlite3'
gem 'nokogiri', '> 1.8.0'
gem 'cssminify'


# --- Utilisation de CSSminify
# Fichier lib/include_css.rb
public def full_build
  return if full_css_present?

  File.write(names[:full], CSSminify.compress(full_content))
end


# --- Diverses façons de produire un numéro de version
# Date à la seconde près.
Time.now.to_i #=> 1515658298

# Date avec plus de précision.
Time.now.to_f.to_s.sub('.', '') #=> "15156583700668073"

# Un «nombre» aléatoire.
require 'securerandom'
SecureRandom.hex(10) #=> "01ad632fdb7390aa55cc"
