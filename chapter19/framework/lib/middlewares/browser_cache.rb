class BrowserCache
  def initialize(app, seconds: 60)
    @app = app
    @seconds = seconds
  end

  def call(env)
    status, headers, body = @app.call(env)

    unless headers["Cache-Control"]
      headers.merge!({"Cache-Control" => "private,max-age=#@seconds"})
    end

    [status, headers, body]
  end
end
