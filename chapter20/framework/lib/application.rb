require 'yaml'
require 'erb'
require 'singleton'
require_relative 'error'
require_relative 'logging'
require_relative 'notice'
require_relative 'include_css'
require_relative 'include_javascript'
require_relative 'renderer'
require_relative 'routes'
require_relative 'route'
require_relative 'base_controller'
require_relative 'framework_logger'

Dir.glob('controllers/*.rb') { |filename| require_relative("../#{filename}") }

DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration").chomp,
                    logger: Logger.new("logs/db.log"))
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
    notice = Notice.new(env)
    req = Rack::Request.new(env)
    route.exec_with(req.params, notice)
  rescue E404 => ex
    error_404
  rescue
    error_500
  end
end
