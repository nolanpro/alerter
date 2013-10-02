class Alert
  def start
    queue   = Queue.new
    monitor = Monitor.new queue
    server  = Server.new queue
  end
end


