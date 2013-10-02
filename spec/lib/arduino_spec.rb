require 'spec_helper'

describe Arduino do
  before do
    Arduino.any_instance.stub(:serial).and_return {
      Class.new { def self.gets; "test\n"; end }
    }
    
    @arduino = Arduino.new
  end

  describe "#read" do
    it "should read and chomp the serial port" do
      @arduino.read.should eq "test"
    end
  end

end
