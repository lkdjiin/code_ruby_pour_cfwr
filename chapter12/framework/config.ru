require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'

use Rack::Static, :urls => ["/css", "/js", "/images"], :root => "assets"

run Application.new
