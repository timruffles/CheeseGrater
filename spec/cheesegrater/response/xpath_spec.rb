root = File.dirname(__FILE__) + '/../'
require root + 'spec_helper'

describe CheeseGrater::Response::Xpath do

  Xpath = CheeseGrater::Response::Xpath
  
  before :each do
    setup = YAML.load_file(root + 'fixtures/xpath.yml').keys_to_symbols
    @html = setup[:one]
  end
  
  # it "should allow querying of an xml document by an xpath, and return the field" do
  #   xpath = Xpath.new @xml, true
  #   xpath.query("id('location)@name").should == 'location'
  # end
  
  it "should allow querying of an html document by an xpath, and return the field" do
    xpath = Xpath.new '', true
    xpath.field("//*[@id='location']/@name",@html).should == 'location'
  end

end