require 'serialport'

class Arduino
  def serial
    @sp ||= SerialPort.new(AppConf.arduino, 9600, 8, 1, SerialPort::NONE) 
  end

  def read
    serial.gets.chomp
  end
end

