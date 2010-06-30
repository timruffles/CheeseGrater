require File.dirname(__FILE__) + '/../spec_helper'

describe CheeseGrater::Request::Querystring do
  
  before :each do
    @setup = {:endpoint => 'http://google.com', :fields => {:name => 'john doe', :age => 18}}
    @qs =  CheeseGrater::Request::Querystring.new(@setup)
  end
  
  it "should create a request with a query string from fields" do
    /name=john\+doe/i.should match @qs.endpoint
    /age=18/i.should match @qs.endpoint
  end
  
  it "should add no key params after a slash" do
    @setup[:fields][:no_key] = ['html.html']
    @qs =  CheeseGrater::Request::Querystring.new(@setup)
    /html\.html\?name=john\+doe/i.should match @qs.endpoint
  end
  
  
  
end