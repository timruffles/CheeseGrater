root = File.dirname(__FILE__) 
require root + '/spec_helper'

describe CheeseGrater::Scraper do
  
  before :each do
    @scraper = CheeseGrater::Scraper.new 1,2,3,4
  end
  
  it "should run requests and yield the raw responses" do

    fields = {}
    response_msg = 'Response read!'
    
    request = mock('Request')
    request.should_receive(:fields).and_return(fields)
    request.should_receive(:run).and_yield(response_msg)

    responses = []
    @scraper.send(:make_requests, [request], CheeseGrater::Pager.new) do |raw_response|
      responses << raw_response
    end

    responses.length.should == 1
    responses[0].should == response_msg

  end
  
  context "integration"
  
    it "should yield vos and scrapers" do
      
    end
    
  end
    
  
  
end