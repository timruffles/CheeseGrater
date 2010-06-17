require File.dirname(__FILE__) + '/../../lib/eventscraper'
require 'yaml'

# TODO - Move to Rspec mixin :)

module ScraperTestHelper
  
  # poor man's model validation :)
  def self.check_event e
     (e.date.instance_of? Time).should == true
     e.title.length.should >= 2
     e.description.length.should >= 2
     (e.link =~ /^http:\/\//).should_not == nil
     
     true
   
   rescue ArgumentError => excp
     puts [excp, excp.backtrace]
     return false
   rescue Exception => excp
     puts "Exception in:"
     p e
     raise excp
  end
end