require File.dirname(__FILE__) + '/spec_helper'
require 'yaml'

describe CheeseGrater::Loader do
  
  context "provided a hash" do
    
    before :each do
      @simple_scrape = YAML.load <<-YAML
        TheGroup:
          request:
            format: not wanted
          AScraper:
            root: true
            request:
              format: http
            response:
              format: xpath
          Another:
            request:
              format: http
            response:
              format: xpath
      YAML
      CheeseGrater::Scraper.stub!(:create)
      @thecheese = CheeseGrater::Loader.new
    end
  
    it "should accept a hash of scrapers and turn them into runnable scrapers" do
      CheeseGrater::Scraper.should_receive(:create).and_return({})
      @thecheese.load_scrapers @simple_scrape
      @thecheese.scrapers[:TheGroup].length.should == 2
    end
    
    it "should turn inherited and instance setup into a mix" do
      
      child = {:request => {:type=>'child', :fields => {:key =>'override key'}}}
      parent = {:request => {:type=>'parent', :fields => {:key =>'parent key', :compare_recursive => 'other'}}}
      expected = {:request => {:type=>'child', :fields => {:key =>'override key', :compare_recursive => 'other'}}}
      
      @thecheese.prepare_scraper_setup(child, parent).should == expected
                                       
    end
    
    it "should recognize and provide the setup to all dependent scrapes in a given set of fields" do
      # setups = <<-YAML
      #   EventBrite:
      #     Scraper:
      #       presetup: dependent
      #     Observer:
      #       presetup: should also be present
      #       even:
      #         nested: should be mixed
      #         so: this should be present, when the others key is overridden
      # YAML
      # result = @thecheese.get_dependent_scrapers({'key' =>'override key', 
      #   :compare_recursive => 'other',
      #   :EventBrite_Scraper => {'setup'=>'of dependent'},
      #   :EventBrite_Observer => {'should'=>'be passed in setup field'}
      # },setups.keys_to_symbols)
      # result.should == {
      #   'EventBrite::Scraper' => {'setup'=>'of dependent','presetup'=>'dependent'},
      #   'EventBrite::Observer' => {'should'=>'be passed in setup field','presetup'=>'dependent'}
      # }
    end
  
    it "should give access to all root scrapers"
    
    
  end
  
end