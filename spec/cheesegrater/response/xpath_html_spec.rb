root = File.dirname(__FILE__) + '/../'
require root + 'spec_helper'

describe CheeseGrater::Response::XpathHtml do

  XpathHtml = CheeseGrater::Response::XpathHtml
  
  before :each do
    setup = YAML.load_file(root + 'fixtures/xpath.yml').keys_to_symbols
    @html = setup[:one]
    @xpath = XpathHtml.new
    @xpath.raw = @html
  end
  
  context "when requested for an individual bit of data" do
    
    
    it "should return the inner content of a node with HTML inside with the HTML in the output" do
      /</.should match @xpath.value('//*[@id="location"]')
    end
    
  end
  
end