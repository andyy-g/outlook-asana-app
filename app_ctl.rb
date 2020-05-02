#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.require

Dotenv.load

pwd  = File.dirname(File.expand_path(__FILE__))
file = pwd + '/app.rb'

Daemons.run_proc(
  'outlook_asana_app', # name of daemon
  #  :dir_mode => :normal
  #  :dir => File.join(pwd, 'tmp/pids'), # directory where pid file will be stored
  #  :backtrace => true,
  #  :monitor => true,
  :log_output => true
) do
  exec "ruby #{file}"
end

