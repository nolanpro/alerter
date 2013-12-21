require 'thread'
require 'dante'
require 'gcm'
require 'sqlite3'

class AppConf
  class << self
    # attr_accessor :ip, :port, :arduino, :database, :monitor_thread, :api_key
    attr_accessor :monitor_thread
    
    def load
      file = File.dirname(__FILE__) + "/../config/config.json"
      config = JSON.parse(IO.read(file))
      config.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_accessor, key)
      end

      require './lib/arduino.rb'
      require './lib/messenger.rb'
      require './lib/monitor.rb'
      require './lib/server.rb'
      require './lib/thread_queue.rb'
    end

  end
end

