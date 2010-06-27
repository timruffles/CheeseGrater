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
  
  it "should return requests for individual bits of data as a scalar value" do
    
    found = []
    values = []
    @xpath.items
    
    values.inject(0) {|a, v| a += v.to_i}.should == 110
    found.length.should == 5
    
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