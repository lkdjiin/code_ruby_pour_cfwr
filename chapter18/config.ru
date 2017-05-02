class Application
  def call(env)
    [200, {}, [env["PATH_INFO"]]]
  end
end

class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    env["PATH_INFO"].upcase!
    @app.call(env)
  end
end

use Middleware
run Application.new
