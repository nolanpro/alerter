require 'singleton'

class ThreadQueue
  include Singleton
  
  def put(item)
    queue.clear
    queue << item
  end

  def get
    return nil if queue.empty?
    queue.pop
  end

  private

  def queue
    @queue ||= Queue.new
  end

end
