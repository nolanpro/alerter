require 'singleton'
class Db
  include Singleton

  def db
    unless @db
      db_exists = File.exists?(AppConf.database)
      @db = SQLite3::Database.new(AppConf.database)
      setup unless db_exists
    end
    @db
  end

  def method_missing(method, *args)
    db.send(method, *args)
  end


  def log(txt)
    db.execute("insert into log values ( NULL, datetime('now'), ?)", txt)
  end
  
  private

  def setup 
    create_conf_table
    create_log_table
  end

  def create_conf_table
    clog "Creating config table"
    db.execute("drop table if exists config");
    db.execute("create table config(key varchar(30) primary key, value text)")
  end

  def create_log_table
    clog "Creating log table"
    db.execute("drop table if exists log");
    db.execute("create table log(id integer primary key, time datetime, value text)")
  end

end
