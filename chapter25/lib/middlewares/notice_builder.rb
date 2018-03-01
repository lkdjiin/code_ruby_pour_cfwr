class NoticeBuilder

  SESSION = "rack.session"
  FRAMEWORK_NOTICE = "framework.notice"
  NOTICE = "notice"

  def initialize(app)
    @app = app
  end

  def call(env)
    @env = env

    set_framework_notice

    status, headers, body = @app.call(@env)

    set_session_notice

    [status, headers, body]
  end

  private

  def set_framework_notice
    @env.store(FRAMEWORK_NOTICE, @env[SESSION].delete(NOTICE))
  end

  def set_session_notice
    @env[SESSION].store(NOTICE, @env[FRAMEWORK_NOTICE]) if framework_notice?
  end

  def framework_notice?
    @env[FRAMEWORK_NOTICE]
  end
end
