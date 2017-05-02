class Routes
  def initialize
    @routes = {}
  end

  def config(&block)
    instance_eval &block
  end

  def get(path, route_to:)
    @routes[["get", path]] = Route.new(route_to)
  end

  def post(path, route_to:)
    @routes[["post", path]] = Route.new(route_to)
  end

  def find(verb, path)
    key = [verb.downcase, path.downcase]
    @routes[key] or raise E404
  end
end
