require 'spec_helper'
require 'rack/test'

describe Server do

  include Rack::Test::Methods

  def app
    @app ||= Server.new!
  end

  before do
    ThreadQueue.instance.clear
  end

  describe "#get" do
    it "should return a json string" do
      get "/"
      File.open("result.html", 'w') { |file| file.write(last_response.body) }
      last_response.should be_ok
      result = JSON.parse(last_response.body)
      result.should be_a Hash
      result['result'].should eq "nada"
    end
  end

  describe "#handle_request" do
    it "should register a device id if provided" do
      Messenger.should_receive(:register).with("12345").once
      get '/?device_id=12345'
    end

    it "should return the queue item if no device id" do
      ThreadQueue.instance.put({result: "Hello"})
      get "/"
      result = JSON.parse(last_response.body)
      result['result'].should eq "Hello"
    end
  end

end
