require File.dirname(__FILE__) + '/../spec_helper'

#module EventScraper
#  describe EventBrite, "connects to API" do 
#    
#    context "given multiple categories and locations" do
#      meetup = EventBrite.new({'topics'=>['business','entrepreneurship'], 'locations'=>[['gb','london'],['gb','manchester']]})
#      it "creates a list of all topic and location combination" do
#        pending("write scraper for eventbrite")
#
#        pairs = meetup.send :create_location_pairs
#        pairs.length.should == 4
#        
#      end
#      it "yields a new scraper for each pair when run" do
#        pending("write scraper for eventbrite")
#        
#        events = []
#        meetup.scrape do |yielded|
#          events.push(yielded)
#        end
#        
#        (events.all? do |yielded|
#          yielded.respond_to? :scrape
#        end).should == true
#        events.length.should == 4
#        
#      end
#    end
#  end
#
#  describe EventBriteTopicLocation, "requests events by topic and location" do 
#    context "give a topic and location" do
#      key = '601b6869351a5d69521e40232f4a1a65'
#      loc = ['GB','london']
#      topic = 'business'
#      type = 'event'
#      
#      meetup = EventBriteTopicLocation.new key, topic, loc
#      it "creates a url ready for api request" do
#        url = meetup.send(:create_request_url,*[type,key,{'country'=>loc[0],'city'=>loc[1],'topic'=>topic}])
#        url.should =~ Regexp.new("^http://api.meetup.com/2/#{type}.json/\\?key=#{key}")
#        url.include?('city=london').should == true
#        url.include?('country=gb').should == true
#      end
#      
#      context "when run" do
#        it "should yield event for all events present in meetup JSON" do
#
#          events = []
#          
#          File.open(File.dirname(__FILE__) + '/fixtures/meetup.json') do |meetup_data|
#            meetup.parse(meetup_data) do |event|
#              events << event
#            end
#          end
#          
#          events.length.should == 53
#          (events.all? do |e|
#             ScraperTestHelper.check_event(e)
#          end).should == true
#        end
#      end
#    end
#  end
#end