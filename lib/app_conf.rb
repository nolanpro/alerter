require 'thread'
require 'dante'
require 'net/http/server'
require 'rack'
require 'json'
require 'gcm'
require 'sqlite3'

require 'alert'
require 'arduino'
require 'messenger'
require 'monitor'
require 'server'

module AppConf
  extend self
  attr_accessor :ip, :port, :arduino, :database, :monitor_thread, :api_key
  
  def db
    @@db ||= SQLite3::Database.new(self.database)
    @@db.results_as_hash = true
    @@db
  end

  def setup 
    create_conf_table
    create_log_table
  end

  def clog(txt)
    # puts txt 
  end

  def log(txt)
    db.execute("insert into log values ( NULL, datetime('now'), ?)", txt)
  end

  def create_conf_table
    clog "Creating config table"
    db.execute("drop table if exists config");
    db.execute("create table config(key varchar(30) primary key, value text)")
    clog "DONE"
  end

  def create_log_table
    clog "Creating log table"
    db.execute("drop table if exists log");
    db.execute("create table log(id integer primary key, time datetime, value text)")
    clog "DONE"
  end
end

AppConf.database = File.dirname(__FILE__) + "/../db/alert.db"
AppConf.arduino = "/dev/ttyACM0"
AppConf.ip = "192.168.2.116"
AppConf.api_key = "AIzaSyCUG7hnOn_tbJVTuMBzugty_otWFi8S6Us"
AppConf.port = 3300
