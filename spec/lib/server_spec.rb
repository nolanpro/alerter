require 'spec_helper'
require 'rack/test'
require 'ap'

describe Server do
  before do
  end

  include Rack::Test::Methods
  def app
    Sinatra::Application
  end

  describe "#get" do
    it "should return a json string" do
      get "/"
      ap last_response
      last_response.should be_ok
      JSON.parse(last_response.body).should be_a Hash
    end
  end

  describe "#handle_request" do
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
