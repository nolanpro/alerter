class Server
  
  def initialize(queue)
    @queue = queue
    start_server
  end

  def start_server
    Net::HTTP::Server.run(:port => AppConf.port) do |request, stream|
      result = handle_request request
      [200, {'Content-Type' => 'application/json'}, [result.to_json]]
    end
  end

  def handle_request(request)
    params = Rack::Utils.parse_nested_query request[:uri][:query].to_s
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
      @queue.empty? ? {result: "nada"} : @queue.pop
    end
  end

end
