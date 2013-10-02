require 'spec_helper'

describe Server do
  before do
    Net::HTTP::Server.stub(:run)
  end

  it "should start the server" do
    Server.any_instance.should_receive(:start_server).once
    @server = Server.new(Queue.new)
  end

  it "should use net http server" do
    Net::HTTP::Server.should_receive(:run).with(port: 3300)
    @server = Server.new(Queue.new)
  end

  describe "handling the request" do
    before do
      @queue = Queue.new
      @server = Server.new(@queue)
      @request = { uri: { query: "" }}
    end

    it "should register a device id if provided" do
      Rack::Utils.should_receive(:parse_nested_query).and_return({"device_id" => "12345"})
      Messenger.should_receive(:register).with("12345").once
      @server.handle_request(@request).should eq({result: "ok"})
    end

    it "should return the queue item if no device id" do
      Rack::Utils.should_receive(:parse_nested_query).and_return({})
      @queue << "Hello"
      @server.handle_request(@request).should eq("Hello")
    end
  end

end
