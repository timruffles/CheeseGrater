require File.dirname(__FILE__) + '/../spec_helper'

module EventScraper
  describe BusinessLink do
    context "when passed the starting businesslink events page with the date selection dropdown" do
      it "should yield urls for all event pages by date" do
        @scraper = BusinessLink.new(File.dirname(__FILE__) + '/fixtures/business_link.html')
        urls = []
        sample = @scraper.scrape do |yielded|
          urls.push(yielded.url)
        end
        urls.length.should == 18
        (urls.all? {|url| (url =~ /^http:\/\//) != nil}).should == true
      end
    end
  end

  describe BusinessLinkLevel2 do
    context "started on the events page for a date, passed from BusinesLink" do
      context "when it has a page with both events, and a url for the next page link" do
        it "should yield events for all events, and a URL for the next page" do
          @scraper2 = BusinessLinkLevel2.new(File.dirname(__FILE__) + '/fixtures/business_link2.html')
          urls, events = [], []
          sample = @scraper2.scrape do |yielded|
            (yielded.respond_to?(:scrape) ? urls : events).push yielded
          end
    
          urls.length.should == 1
          events.length.should == 10
          events.all? {|event| ScraperTestHelper.check_event(event)}.should == true
        end
      end

      context "when passed the businesslink page at the end of the paginator" do
        it "should yield events for all events, but no urls" do
          @scraper2 = BusinessLinkLevel2.new(File.dirname(__FILE__) + '/fixtures/business_link2_2.html')
          urls, events = [], []
          sample = @scraper2.scrape do |yielded|
            (yielded.respond_to?(:scrape) ? urls : events).push yielded
          end
          urls.length.should == 0
          events.length.should == 10
          events.all? {|event| ScraperTestHelper.check_event(event)}.should == true
        end
      end
    end
  end  
end