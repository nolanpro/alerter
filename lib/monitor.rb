class Monitor
  attr_accessor :thread

  def run!
    @messenger = Messenger.new
    @queue = ThreadQueue.instance
    clear_log
    thread = Thread.new do
      start_monitor
    end
  end

  def check(watts, alarm)
    if alarm > 0
      # TODO: not working yet, lots of false alarms from arduino
      # @messenger.gcm("alarm")
    end
    # cooldown fan runs about 45 watts
    if watts > 55
      @messenger.gcm("watts")
    end
  end

  def clear_log
    Db.instance.create_log_table
  end
  
  # arduino gives off random numbers for first few
  # iterations, so lets forget about the first 20
  def buffer_check
    @reads ||= 0
    if @reads > 20
      yield
    end
    @reads += 1 if @reads <= 20
  end

  def start_monitor
    arduino = Arduino.new
    while true do
      read_arduino(arduino)
    end
  end

  def read_arduino(arduino)
    result = arduino.read
    watts, amps, alarm = result.split(" ")
    
    buffer_check do
      # AppConf.log result if alarm.to_i > 0
      check(watts.to_f, alarm.to_i)
    end

    @queue.put({watts: watts, amps: amps, alarm: alarm})
  end
end
