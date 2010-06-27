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
      @xpath.value('//*[@id="add_maincontent"]/@name').should == 'main-content'
    end
    
    it "should return a scalar when given a path that yields a node" do
      @xpath.value('//*[@id="eventDate"]/*[@value="99"]').should == 'Any date'
    end
    
    it "should return a scalar when given a path that yields a node set" do
      found = @xpath.value('//*[@id="location"]') 
      %w[All North East England ---Northumberland ---Tyne and Wear].each do |scalar|
        found.include?(scalar).should == true
      end
    end
    
    it "should return nil when given a path that yields nothing" do
      @xpath.value('//*[@id="ss"]').should == nil
    end
    
    it "should return the inner content of a node with XML, without XML nodes" do
      /</.should_not match @xpath.value('//*[@id="location"]')
    end
    
  end
  
  it "should yield up fields as hashes of scalar values" do
    
    found = []
    values = []
    @xpath.items("//*[@id='location']/*[@value!='-999']",{:value=>'./@value'}) do |fields|
      found << fields
      values << fields[:value]
    end
    
    values.inject(0) {|a, v| a += v.to_i}.should == 110
    found.length.should == 5
    
  end

end