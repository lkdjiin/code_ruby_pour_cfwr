require 'yaml'
require 'erb'
require_relative 'renderer'
require_relative 'routes_builder'
require_relative 'base_controller'

Dir.glob('controllers/*.rb') { |filename| require_relative("../#{filename}") }

DB = Sequel.connect('sqlite://db/database.sqlite')
Dir.glob('models/*.rb') { |filename| require_relative("../#{filename}") }

class Application

  def initialize
    builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
    builder.build
    @routes = builder.routes
  end

  def call(env)
    exec(@routes[env['PATH_INFO']], env)
  rescue
    fail("No matching routes")
  end

  private

  def exec(route, env)
    req = Rack::Request.new(env)
    controller = Object.const_get(route['controller']).new(req.params)
    controller.send(route['method'])
  end
end
