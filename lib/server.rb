require "sinatra/base"
require "sinatra/json"
require "logger"

class Server < Sinatra::Base
  helpers Sinatra::JSON
  set :bind, AppConf.ip
  set :port, AppConf.port

  get "/" do
    json handle_request(params)
  end

  def handle_request(params)
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
      item = ThreadQueue.instance.get
      return {result: "nada"} if item.nil?
      item
    end
  end

end
