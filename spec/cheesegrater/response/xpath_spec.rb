root = File.dirname(__FILE__) + '/../'
require root + 'spec_helper'

describe CheeseGrater::Response::Xpath do

  Xpath = CheeseGrater::Response::Xpath
  
  before :each do
    setup = YAML.load_file(root + 'fixtures/xpath').keys_to_symbols
    @fixture1 = setup[:one]
  end
  
  it "should allow querying by an xpath, and return the field" do
    xpath = Xpath.new @fixture1
    xpath.query("id('location)@name").should == 'location'
  end

end