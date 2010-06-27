require File.dirname(__FILE__) + '/../spec_helper'

include CheeseGrater::Request

describe Base do

  it "should expose a method to entirely set its state" do
    req = Base.new

    req.setup({:endpoint => 'blah', :fields => {:a =>'e'}})

    req.endpoint.should == 'blah'
    req.fields.should == {:a => 'e'}

  end
end


