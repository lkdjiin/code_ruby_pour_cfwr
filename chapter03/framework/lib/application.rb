require 'yaml'
require_relative 'renderer'
require_relative 'routes_builder'
require_relative 'base_controller'

Dir.glob('controllers/*.rb') { |filename| require_relative("../#{filename}") }

class Application

  def initialize
    builder = RoutesBuilder.new(YAML.load_file("routes.yml"))
    builder.build
    @routes = builder.routes
  end

  def call(env)
    exec @routes[env['REQUEST_PATH']]
  rescue
    fail("No matching routes")
  end

  private

  def exec(route)
    controller = Object.const_get(route['controller']).new
    controller.send(route['method'])
  end
end
