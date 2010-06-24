root = File.dirname(__FILE__) 
require root + '/spec_helper'

include CheeseGrater

describe CheeseGrater::Scraper do
  
  before :each do
    @scraper = CheeseGrater::Scraper.new 1,2,3,4
    @fixtures = YAML.load_file(root + '/fixtures/scraper.yml').keys_to_symbols
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
  
  context "integration" do
  
    it "should yield vos and scrapers" do
      
      vos = []
      vos << Vo.new({:fields => {:location_code => "./@value"},:related_to => {},:item_path => "//*[@id='location']/*[@value!='-999']"})
      response = Response::Xpath.new(@fixtures[:one],true)
      
      results = []
      @scraper.send(:read_response, vos, response, {}) do |scraped|
        results << scraped
      end
      
      total_of_vals = results.inject(0) do |acc, vo|
        acc += vo.fields[:location_code].to_i
      end
      
      results.length.should > 0
      total_of_vals.should == 110
    end
    
  end
    
  
  
end