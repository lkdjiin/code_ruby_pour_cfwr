class Notice
  KEY = "framework.notice"

  def initialize(env)
    @env = env
    @value = @env.delete(KEY)
  end

  def value=(v)
    @env.store(KEY, v)
  end

  attr_reader :value
end
