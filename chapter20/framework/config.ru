require 'logger'
require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'
require_relative 'lib/middlewares/public_txt'
require_relative 'lib/middlewares/api_switcher'
require_relative 'lib/middlewares/notice_builder'
require_relative 'lib/middlewares/browser_cache'

use Rack::CommonLogger, Logger.new('logs/rack.log')
use TrailingSlashRemover
use PublicTxt
use APISwitcher
use BrowserCache
use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"
use NoticeBuilder

run Application.new(logger: Logger.new("logs/app.log"))
