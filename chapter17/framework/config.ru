require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
require_relative 'lib/middlewares/trailing_slash_remover'

use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"

run Application.new
