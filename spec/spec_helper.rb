require File.dirname(__FILE__) + '/../lib/eventscraper'
require 'yaml'

# TODO - Move to Rspec mixin :)

module ScraperTestHelper
  def self.check_event e
     Date.parse(e.date)
     e.title.length.should >= 2
     e.description.length.should >= 2
     (e.link =~ /^http:\/\//).should_not == nil
     
     true
   rescue ArgumentError => excp
     puts [excp, excp.backtrace]
     return false
  end
end