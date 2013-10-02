require 'spec_helper'

describe Monitor do
  before do
    @queue = Queue.new
    Monitor.any_instance.stub(:start_monitor)
    @monitor = Monitor.new(@queue)
  end

  after do
    AppConf.monitor_thread.join unless AppConf.monitor_thread.nil?
  end

  describe "#initialize" do
    it "should create a new messenger and start monitor the thead" do
      Messenger.should_receive(:new)
      Monitor.new @queue
    end
  end

  describe "#read_arduino" do
    before do
      Arduino.any_instance.stub(:serial)
      @monitor.stub(:buffer_check).and_yield
      @arduino = Arduino.new
    end
    
    it "should check the results" do
      Arduino.any_instance.should_receive(:read).and_return("100.0 1.0 1")
      @monitor.should_receive(:check).with(100.0, 1)
      @monitor.read_arduino @arduino
    end
  end

  describe "#check" do
    it "should send an alarm warning" do
      pending "Not working yet, commented out in monitor.rb"
      Messenger.any_instance.should_receive(:gcm).with("alarm")
      @monitor.check(5.0, 1)
    end

    it "should send a watts warning" do
      Messenger.any_instance.should_receive(:gcm).with("watts")
      @monitor.check(75.0, 0)
    end
  end

  describe "#buffer_check" do
    before do
      @arduino = Arduino.new
      @arduino.stub(:read).and_return("100.0 1.0 1")
    end

    it "should not check for alerts if has had less than 20 reads" do
      @monitor.should_not_receive(:check)
      15.times { @monitor.read_arduino @arduino }
    end

    it "should check for alerts after 20 reads" do
      @monitor.should_receive(:check).with(100.0, 1)
      22.times { @monitor.read_arduino @arduino }
    end
  end
  
end
