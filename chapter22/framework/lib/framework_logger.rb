class FrameworkLogger
  include Singleton

  attr_accessor :logger

  def self.info(message)
    instance.logger.info(message)
  end
end
