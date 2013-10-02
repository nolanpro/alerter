class Messenger
  def initialize
    @message_sent_at = {}
  end

  def gcm(type, reset = false)
    puts "Resettin'" if reset

    return if Time.now.to_i - last_sent_at(type) < 600

    puts "Sending message: #{type}"
    gcm = GCM.new(AppConf.api_key)
    registration_ids = [device_id]
    options = {data: {"message" => type} }
    response = gcm.send_notification(registration_ids, options)

    set_sent type, reset
    puts "sent: #{@message_sent_at} now: #{Time.now}"
  end

  def last_sent_at(type)
    (@message_sent_at[type] ||= Time.at(0)).to_i
  end

  def set_sent(type, reset)
    @message_sent_at[type] = reset ? Time.at(0) : Time.now
  end

  def device_id
    AppConf.db.get_first_row("select * from config where key = 'gcm_id'")["value"]
  end

  def self.register(id)
    AppConf.db.execute("insert or replace into config (key,value) values ('gcm_id', ?)", id)
  end

end
