class TrailingSlashRemover
  def initialize(app)
    @app = app
  end

  def call(env)
    env["PATH_INFO"] = env["PATH_INFO"].sub(%r{/$}, '')
    @app.call(env)
  end
end
