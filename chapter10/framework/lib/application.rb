require 'yaml'
require 'erb'
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

  def initialize
    @routes = Routes.new(YAML.load_file("routes.yml"))
  end

  def call(env)
    route = @routes.find(env["REQUEST_METHOD"], env["PATH_INFO"])
    req = Rack::Request.new(env)
    route.exec_with(req.params)
  rescue
    fail("No matching routes")
  end

end
