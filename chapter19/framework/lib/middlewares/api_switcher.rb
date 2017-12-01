class APISwitcher
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ %r{\A/v\d+/}
      env.store("framework.api", true)
    end

    @app.call(env)
  end
end
