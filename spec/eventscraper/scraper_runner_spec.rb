require File.dirname(__FILE__)  + '/spec_helper'

describe "scraper runner" do
  
  class ScraperMock < Scraper
    def scrape 
      yield "thing"
    end
  end
  
  module Resque
    def self.enqueue(thing,*args)
      (@@que ||= []) << thing
    end
    def self.que
      @@que
    end
  end
  
  scraper = ScraperMock.new
  marshaled = Marshal.dump(scraper)
  
  runner = ScraperRunner.new
  context "passed a marshal'd scraper" do
    it "should yield an event which is added to the resque que" do
      runner.perform(marshaled)
      Resque.que.length.should == 1
      Resque.que.shift.should == EventSaver
    end
    
  end
end