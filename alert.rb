$:.unshift File.dirname(__FILE__) + "/lib"
require 'app_conf'

Dante.run("alerter") do |opts|
  alert = Alert.new
  alert.start
end

# sudo /home/pi/alert/ruby/alert -d -P /home/pi/alert/ruby/alert.pid -l /home/pi/alert/ruby/logs/output.log 
# sudo /home/pi/alert/ruby/alert -k -P /home/pi/alert/ruby/alert.pid
