require "sinatra/base"
require "sinatra/json"
require "logger"

class Server < Sinatra::Base
  helpers Sinatra::JSON
  set :port, AppConf.port

  class << self
    attr_accessor :queue
  end

  get "/" do
    json handle_request(params)
  end

  def handle_request(params)
    queue = {}
    if params["device_id"]
      puts params["device_id"]
      Messenger.register params["device_id"]
      {result: "ok"}
    elsif params["test"]
      m = Messenger.new
      m.gcm(params["test"], true)
      {result: "test sent"}
    else # stats request
      puts "Sending.."
      queue.empty? ? {result: "nada"} : queue.pop
    end
  end

end
