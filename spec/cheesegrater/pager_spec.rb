root = File.dirname(__FILE__) 
require root + '/spec_helper'

include CheeseGrater

describe Pager do
  
  before :each do
    @request = mock(Request::Base)
    @request.stub(:run)
    @request.stub(:setup)
    @pager = Pager.create
  end
  
  context "given an empty setup" do
    it "should run at least one page" do
      
      @request.stub(:run).and_return('raw')
      
      runs = 0
      
      @pager.page(@request) do |raw_result|
        runs += 1
        raw_result.should == 'raw'
        
        # stop other requests
        false
      end
      
      runs.should == 1
      
    end
  end
  
  it "should modify the request setup" do
    
    url_path = '//blah'
    pager = Pager.create(:next_page_complete_endpoint => url_path)
    
    response = mock('Response')
    response.stub(:scalar_query).with(url_path).and_return('http://example')
    @request.stub(:run)
    
    setups = []
    @request.stub(:setup) do |setup|
      setups << setup
    end
    
    runs = 0
    pager.page(@request) do
      response.stub(:scalar_query).with(url_path).and_return(false) if (runs += 1) > 1
      response
    end
    setups.length.should == 2
    first_setup, second_setup = setups
    first_setup.should == {}
    second_setup.should == {:endpoint => 'http://example', :fields => {}}
    
  end
  
  context "only given a next page url" do
    it "should be able to yield requests until no url is given" do
      
      url_path = '//blah'
      pager = Pager.create(:next_page_complete_endpoint => url_path)
      
      response = mock('Response')
      response.should_receive(:scalar_query).with(url_path).and_return('http://example')
      @request.stub(:run).and_return(response)
      
      runs = 0
      pager.page(@request) do
        
        runs += 1
        
        response.stub(:scalar_query)
        response
      end
      runs.should == 2
    end
  end
  
  context "given a page field" do
    context "only" do
      it "should be page to yield requests until the request fails"
    end
    context "with a last page" do
      it "should yield all possible pages immediately"
    end
  end
  
  context "given onluy a per page, and total items" do
    it "should immediately yield all possible requests"
  end
  
end