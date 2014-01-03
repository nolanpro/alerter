#!/usr/bin/env ruby

require './lib/app_conf.rb'
require 'awesome_print'

AppConf.load

Dante.run("alerter") do |opts|
  monitor = Monitor.new
  monitor.run!

  Server.run!
end

# sudo /home/pi/alert/ruby/alert -d -P /home/pi/alert/ruby/alert.pid -l /home/pi/alert/ruby/logs/output.log 
# sudo /home/pi/alert/ruby/alert -k -P /home/pi/alert/ruby/alert.pid
