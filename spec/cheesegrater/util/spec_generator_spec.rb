root = File.dirname(__FILE__) 
require root + '/../spec_helper'

include CheeseGrater::Util

describe SpecGenerator do
  
  before :each do
    
    SpecGenerator.create(Scraper.new ({:vos => Vo.new, :scraper}))
    
  end
  
  it "should create and populate a spec file if none exists" do
    
  end
  
  it "should ignore a spec file if one exists"
  
  it "should create a fixture file if none exists"
  
  it "should update a fixture file if one exists"
  
  it "should repeat the process for any other scrapers found"
  
  
end