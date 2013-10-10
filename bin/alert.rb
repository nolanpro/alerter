require './lib/app_conf.rb'

AppConf.database = File.dirname(__FILE__) + "/../db/alert.db"
AppConf.arduino = "/dev/ttyACM0"
AppConf.api_key = "AIzaSyCUG7hnOn_tbJVTuMBzugty_otWFi8S6Us"
AppConf.port = 3300

require './lib/arduino.rb'
require './lib/messenger.rb'
require './lib/monitor.rb'
require './lib/server.rb'

Dante.run("alerter") do |opts|
  queue   = Queue.new
  monitor = Monitor.new queue
  
  Server.queue = queue
  Server.run!
end

# sudo /home/pi/alert/ruby/alert -d -P /home/pi/alert/ruby/alert.pid -l /home/pi/alert/ruby/logs/output.log 
# sudo /home/pi/alert/ruby/alert -k -P /home/pi/alert/ruby/alert.pid
