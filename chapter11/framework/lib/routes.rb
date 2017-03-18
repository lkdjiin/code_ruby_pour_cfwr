class Routes
  def initialize(routes_from_file)
    @routes = {}
    routes_from_file.each {|key, value| @routes[key] = Route.new(value) }
  end

  def find(verb, path)
    key = [verb.downcase, path.downcase.sub(%r{/$}, '')]
    @routes[key] or raise E404
  end
end
