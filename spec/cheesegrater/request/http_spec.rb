require File.dirname(__FILE__) + '/../spec_helper'

describe CheeseGrater::Request::Http do

  before :each do
    @setup = {:endpoint => 'http://google.com', :method => 'get'}
    @http =  CheeseGrater::Request::Http.new(@setup)
  end

  it "should require a request :method in config" do
    CheeseGrater::Request::Http.new @setup # works
    @setup.delete(:method)
    lambda do
      CheeseGrater::Request::Http.new @setup
    end.should raise_error(CheeseGrater::Request::Http::InvalidOrMissingRequestMethod)
  end

  it "should load the endpoint and return the response body" do
    @http.run do | response |
      /feeling lucky/i.should match(response)
    end
  end
end
