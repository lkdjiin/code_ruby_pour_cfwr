require 'yaml'
require 'erb'
require_relative 'error'
require_relative 'notice'
require_relative 'include_css'
require_relative 'include_javascript'
require_relative 'renderer'
require_relative 'routes'
require_relative 'route'
require_relative 'base_controller'

Dir.glob('controllers/*.rb') { |filename| require_relative("../#{filename}") }

DB = Sequel.connect('sqlite://db/database.sqlite')
Dir.glob('models/*.rb') { |filename| require_relative("../#{filename}") }

class Application
  include Error

  def self.routes
    @@routes
  end

  def initialize
    @@routes = Routes.new
    require "./routes"
  end

  def call(env)
    route = @@routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    notice = Notice.new(env["rack.session"])
    req = Rack::Request.new(env)
    route.exec_with(req.params, notice)
  rescue E404 => ex
    error_404
  # rescue
  #   error_500
  end
end
