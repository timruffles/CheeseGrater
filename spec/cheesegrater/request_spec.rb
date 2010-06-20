require File.dirname(__FILE__) + '/spec_helper'

describe CheeseGrater::Request do
  
  before :each do
    
    @request = YAML.load( <<-YAML
      format: querystring
      endpoint: http://blah.com
      fields:
          country: GB
          keywords:
              type: csv
              value: [hippo, mustapha, ghandi]
    YAML
    ).keys_to_symbols
    
    
    @per_request = YAML.load( <<-YAML
      format: querystring
      endpoint: http://blah.com
      fields:
          country: GB
          keywords:
              type: one_per_request
              value: [hippo, mustapha, ghandi]
    YAML
    ).keys_to_symbols
    
    @multiple_per_request = YAML.load( <<-YAML
      format: querystring
      endpoint: http://blah.com
      fields:
          country: GB
          keywords:
              type: one_per_request
              value: [hippo, mustapha, ghandi]
          type:
              type: one_per_request
              value: [one, two, three]
    YAML
    ).keys_to_symbols
    
    
  end
  
  it "should format csv type fields correctly" do
    
    additional = []
    
    fields = CheeseGrater::Request.prepare_fields_and_override_hashes(@request[:fields]) do |yielded|
      additional << yielded
    end
    
    fields[:keywords].should == %w[hippo mustapha ghandi].join(',')
    additional.length.should == 0
    
  end

  it "should be able to generated the required overrides for per-request field type" do
    
    additional = []
    
    fields = CheeseGrater::Request.prepare_fields_and_override_hashes(@per_request[:fields]) do |yielded|
      additional << yielded
    end
    
    # should yield an override for the second two: the first value is used in the main request
    additional.length.should == 2
    %w[mustapha ghandi].each do |expected_arg| 
      (additional.select do |hash|
        hash[:keywords] == expected_arg
      end).length.should == 1 # one and only one request should have each of the per-request values
    end
    
  end
  
  it "should not allow multiple per-request varialbes " do
    
     lambda {
       CheeseGrater::Request.prepare_fields_and_override_hashes(@multiple_per_request[:fields]) {}
     }.should raise_error(CheeseGrater::Request::MultiplePerRequestFieldError)
    
  end
  
  it "should create a request of the correct type with all fields" do
    
    request = CheeseGrater::Request.create @request
    request.instance_eval do
      CheeseGrater::Request::Querystring.should === self
      fields[:country].should == 'GB'
      fields[:keywords].should_not == nil
    end 
    
  end
  
end

