require 'spec_helper'

describe Alert do
  
  before do
    @alert = Alert.new
  end

  it "Should start the monitor" do
    Server.any_instance.stub(:start_server)
    Monitor.should_receive(:new).with(kind_of(Queue))
    @alert.start
  end

  it "Should start the server" do
    Monitor.any_instance.stub(:start_monitor)
    Server.should_receive(:new).with(kind_of(Queue))
    @alert.start
  end

end
