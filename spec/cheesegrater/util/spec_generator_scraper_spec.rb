root = File.dirname(__FILE__) 
require root + '/../spec_helper'

include CheeseGrater::Util::SpecGenerator

describe ScraperSpec do
  
  before :each do
    
    test_spec = File.open(root + '/../fixtures/util/spec_tmp_spec.rb','w') do
      ScraperSpec.spec_code
    end
    
  end
  
  def run_spec
    `"spec #{Dir.realpath(root + '/../fixtures/util/spec_tmp_spec.rb')}"`
  end
  
  it "should test that the scraper successfully fills the response" do
    
    
    
    run_spec
  end
  
  it "should test that the scraper creates all vos"
  
  it "should test that the scraper fills vos related vos"
  
  it "should test that the scraper fills vos related scrapers"
  
  it "should test that the scraper generates scrapers"
  
end