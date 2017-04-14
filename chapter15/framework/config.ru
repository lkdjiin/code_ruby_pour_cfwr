require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'

use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"
use Rack::Session::Cookie, secret: "Chuuuuutttt !"

run Application.new
