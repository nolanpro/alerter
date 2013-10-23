require './lib/app_conf.rb'
AppConf.load

Dante.run("alerter") do |opts|
  queue   = Queue.new
  monitor = Monitor.new queue
  
  Server.queue = queue
  Server.run!
end

# sudo /home/pi/alert/ruby/alert -d -P /home/pi/alert/ruby/alert.pid -l /home/pi/alert/ruby/logs/output.log 
# sudo /home/pi/alert/ruby/alert -k -P /home/pi/alert/ruby/alert.pid
