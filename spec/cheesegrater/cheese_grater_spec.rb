require File.dirname(__FILE__) + '/spec_helper'
require 'yaml'

describe CheeseGrater::Loader do
  
  context "provided a hash" do
    
    before :each do
      @thecheese = CheeseGrater::Loader.new
      @simple_scrape = YAML.load <<-YAML
        TheGroup:
          request:
            format: not wanted
          AScraper:
            request:
              format: http
            response:
              format: xpath
      YAML
    end
  
    it "should accept a hash of scrapers and turn them into runnable scrapers" do
      CheeseGrater::Scraper.should_receive(:create)
      @thecheese.load_scrapers @simple_scrape
    end
  
    it "should throw errors for non existant request and response types" do
      @thecheese.load_scrapers @simple_scrape
    end
  
    it "should give access to all root scrapers"
    
  end
  
end