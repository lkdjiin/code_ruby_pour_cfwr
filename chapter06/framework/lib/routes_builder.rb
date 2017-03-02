class RoutesBuilder
  attr_reader :routes

  def initialize(routes_from_file)
    @routes_from_file = routes_from_file
    @routes = {}
  end

  def build
    @routes_from_file.each { |key, value| @routes[key] = build_route(value) }
  end

  private

  def build_route(values)
    controller, method = values['to'].split('#')
    controller = controller.capitalize + 'Controller'
    { 'via' => values['via'], 'controller' => controller, 'method' => method }
  end
end
