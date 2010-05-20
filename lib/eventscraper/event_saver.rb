# requires rails enviroment
#require 'rails'

class EventSaver
  RAILS_ROOT = "/Users/timruffles/Development/EventRails/"
  RAILS_ENV = "development"
  @queue = :events

  def perform(marshalled_event)
    event_vo = Marshal.load(marshalled_event)
    load_active_record
    Event.create(:title => event_vo.title, :description => event_vo.description)
  end
  
  def load_active_record
    require 'rubygems'
    require 'active_record'
    require 'yaml'
    require 'logger'

    dbconfig = YAML::load(File.open(RAILS_ROOT + 'config/database.yml'))[RAILS_ENV].to_options
    ActiveRecord::Base.establish_connection(dbconfig)
    #ActiveRecord::Base.logger = Logger.new(STDERR)
    #ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))

    require "#{RAILS_ROOT}app/models/Event"
    # TODO - add other models here    
  end
end