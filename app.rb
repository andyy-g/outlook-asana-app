#!/usr/bin/env ruby

require 'bundler'
Bundler.require

Dotenv.load

$:.unshift File.expand_path('./../lib', __FILE__)
require 'app/application'

while true
  Application.new.perform
end
