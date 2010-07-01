root = File.dirname(__FILE__) 
require root + '/spec_helper'

include CheeseGrater

describe Loader do
  
   before :each do
      # all fixtures
      @setup = YAML.load_file(root + '/fixtures/loader.yml').keys_to_symbols
      @thecheese = Loader.new
    end
  
  context "provided a hash" do
    
    context "with mock objects" do
    
      before :each do
        
        @scraper = mock('scraper')
        @scraper.stub(:related_scrapers).and_return({})
        Scraper.stub!(:create).and_return(@scraper)
        
      end
  
      it "should accept a hash of scrapers and turn them into runnable scrapers" do
        Scraper.should_receive(:create)
        @thecheese.load_scrapers @setup[:simple_scrape]
        @thecheese.scrapers[:TheGroup].length.should == 2
      end
    
      it "should turn inherited and instance setup into a mix" do
      
        child = {:request => {:type=>'child', :fields => {:key =>'override key'}}}
        parent = {:request => {:type=>'parent', :fields => {:key =>'parent key', :compare_recursive => 'other'}}}
        expected = {:request => {:type=>'child', :fields => {:key =>'override key', :compare_recursive => 'other'}}}
      
        @thecheese.send(:combine_scraper_with_shared_setup, child, parent).should == expected
                                       
      end
    
      it "should recognize and provide the setup to all dependent scrapes in a given set of fields" do
      
        dependents = @thecheese.send(:prepare_related_scraper_setups, @setup[:related_setup],@setup[:scraper_setup])
      
        dependents.length.should == 1
        dependents[:Observer][:id].should == ['/']
        dependents[:Observer][:even].should == {:nested => 'should be overridden',:so => 'this should be present, when the others key is overridden'}
      end
  
      it "should give access to all root scrapers" do
          @scraper.should_receive(:is_root?).exactly(2).times.and_return(true)
          @thecheese.load_scrapers @setup[:simple_scrape]
          @thecheese.root_scrapers.length == 2
      end
      
    end
    
    context "in integration testing" do
    
      it "should setup this previously problematic setup correctly" do
      
        @thecheese.load_scrapers @setup[:problem_one]
        scrapers = @thecheese.scrapers
        (Vo === scrapers[:Group][:EbOrganiser].get_vo(:Organiser)).should == true
      end
    
    end
    
  end
  
end