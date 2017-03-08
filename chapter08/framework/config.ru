require 'bundler/setup'
Bundler.require(:default)
require_relative 'lib/application'
run Application.new
