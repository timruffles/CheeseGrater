root = File.dirname(__FILE__) + '/../'
require root + 'spec_helper'

describe CheeseGrater::Response::Xpath do

  Xpath = CheeseGrater::Response::Xpath
  
  before :each do
    setup = YAML.load_file(root + 'fixtures/xpath.yml').keys_to_symbols
    @html = setup[:one]
    @xpath = Xpath.new
    @xpath.raw = @html
  end
  
  context "when requested for an individual bit of data" do
    
    it "should return a scalar when given a path that yields an attribute" do
      @xpath.scalar_query('//*[@id="add_maincontent"]/@name').should == 'main-content'
    end
    
    it "should return a scalar when given a path that yields a node" do
      @xpath.scalar_query('//*[@id="eventDate"]/*[@value="99"]').should == 'Any date'
    end
    
    it "should return a scalar when given a path that yields a node set" do
      found = @xpath.scalar_query('//*[@id="location"]') 
      %w[All North East England ---Northumberland ---Tyne and Wear].each do |scalar|
        found.include?(scalar).should == true
      end
    end
    
    it "should return nil when given a path that yields nothing" do
      @xpath.scalar_query('//*[@id="ss"]').should == nil
    end
    
    it "should return the inner content of a node with XML, without XML nodes" do
      /</.should_not match @xpath.scalar_query('//*[@id="location"]')
    end
    
  end
  
  it "should return results to a query" do
    
    found = []
    @xpath.query("//*[@id='location']/*[@value!='-999']").each do |scope|
      found  << scope
    end
    
    found.length.should == 5
    
  end
  
end