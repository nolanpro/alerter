require 'thread'
require 'dante'
require 'gcm'
require 'sqlite3'

class AppConf
  class << self
    attr_accessor :ip, :port, :arduino, :database, :monitor_thread, :api_key
  
    def db
      @@db ||= new_db
      @@db.results_as_hash = true
      @@db
    end

    def new_db
      puts database
      db_exists = File.exists?(database)
      puts db_exists
      db = SQLite3::Database.new(database)
      setup unless db_exists
      db
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
end

