require_relative 'lib/application'
Dir.glob('lib/middlewares/*.rb') { |filename| require_relative("#{filename}") }

if ENV["RACK_ENV"] == "development"
  use Rack::Reloader
end

use Rack::CommonLogger, Logger.new("logs/rack_#{ENV["RACK_ENV"]}.log")
use TrailingSlashRemover
use PublicTxt
use APISwitcher
use BrowserCache
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
use NoticeBuilder

run Application.new(logger: Logger.new("logs/app_#{ENV["RACK_ENV"]}.log"))
