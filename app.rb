require 'bundler'
Bundler.require

Dotenv.load

$:.unshift File.expand_path('./../lib', __FILE__)
require 'app/application'

Application.new.perform
