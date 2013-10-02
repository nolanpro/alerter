require 'spec_helper'

describe Messenger do
  before do
    @messenger = Messenger.new
  end

  describe "#gcm" do
    it "should send a message to gcm" do
      GCM.any_instance.should_receive(:send_notification).and_return("ok")
      r = @messenger.gcm("watts")
    end

    it "should not send a message if one was sent within 10 minutes" do
      @messenger.stub(:last_sent_at).and_return(Time.now.to_i - 60)
      GCM.any_instance.should_not_receive(:send_notification)
      @messenger.gcm("alarm")
    end

    it "should send a message if the last one was over 10 minutes ago" do
      @messenger.stub(:last_sent_at).and_return(Time.now.to_i - 650)
      GCM.any_instance.should_receive(:send_notification)
      @messenger.gcm("alarm")
    end
  end

  describe "#register" do
    it "should save a device id" do
      Messenger.register("abc123")
      @messenger.device_id.should eq "abc123"
    end
  end

end
