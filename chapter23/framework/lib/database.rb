class Database
  def self.setup
    new.setup
  end

  def setup
    Sequel.connect(connection_string, logger: log_file).tap do
      Sequel::Model.plugin :json_serializer
    end
  end

  private

  def connection_string
    ENV["DATABASE_URL"] ||
      File.read("db/configuration_#{ENV["RACK_ENV"]}").chomp
  end

  def log_file
    Logger.new("logs/db_#{ENV["RACK_ENV"]}.log")
  end
end
