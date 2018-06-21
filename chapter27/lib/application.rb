require 'logger'
require 'bundler/setup'
Bundler.require(:default)
require 'yaml'
require 'erb'
require 'singleton'
require_relative 'error'
require_relative 'logging'
require_relative 'notice'
require_relative 'include_css'
require_relative 'include_javascript'
require_relative 'renderer'
require_relative 'api_renderer'
require_relative 'routes'
require_relative 'route'
require_relative 'base_controller'
require_relative 'framework_logger'
require_relative 'database'

Dir.glob('controllers/*.rb') { |filename| require_relative("../#{filename}") }
DB = Database.setup
Dir.glob('models/*.rb') { |filename| require_relative("../#{filename}") }

class Application
  include Error

  def self.routes
    @@routes
  end

  def initialize(logger:)
    @@routes = Routes.new
    require "./routes"
    FrameworkLogger.instance.logger = logger
  end

  def call(env)
    route = @@routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    notice = Notice.new(env)
    req = Rack::Request.new(env)
    route.exec_with(req.params, notice)
  # rescue E404 => ex
  #   env["framework.api"] ? api_error_404 : error_404
  # rescue => ex
  #   env["framework.api"] ? api_error_500(ex.message) : error_500
  end
end
