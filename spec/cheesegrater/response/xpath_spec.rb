root = File.dirname(__FILE__) + '/../'
require root + 'spec_helper'

describe CheeseGrater::Response::Xpath do

  Xpath = CheeseGrater::Response::Xpath
  
  before :each do
    setup = YAML.load_file(root + 'fixtures/xpath.yml').keys_to_symbols
    @html = setup[:one]
    @xpath = Xpath.new @html, true
  end
  # 
  # it "should allow querying of an attribute" do
  #   @xpath.field("//*[@id='location']/@name",::Nokogiri::HTML(@html)).should == 'location'
  # end
  # 
  # it "should allow querying of a node containing nodes" do
  #   field = @xpath.field("//*[@id='location']",::Nokogiri::HTML(@html))
  #   /<option value=\"200\">North West England<\/option>/.should match field
  # end
  
  it "should return items in a way they can be queried" do
    found = []
    values = []
    @xpath.items("//*[@id='location']/*[@value!='-999']",{:value=>'./@value'}) do |fields|
      found << fields
      values << fields[:value]
    end
    
    values.inject(0) {|a, v| a += v.to_i}.should == 110
    
    
  end

end