#require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../../lib/cheesegrater/coreextensions'

describe "Core extensions defined by CheeseGrater" do
  
  context "Module" do
    
    context "define_exception" do
      
       module Tester
          define_exception :TestException, 'The default message'
          define_exception :TestRuntimeException, 'The default message', RuntimeError
       end
    
      it "should allow the user to add an exception class to a module" do
          Tester.constants.include?('TestException').should == true
      end
      
      it "should allow the user to set the default message of that exception" do
        e = Tester::TestException.new
        e.to_s.should == 'The default message'
        e = Tester::TestException.new "A message"
        e.to_s.should == "A message"
      end
      
      it "should allow the user to set the type of that exception" do
        e = Tester::TestException.new
        (RuntimeError === e).should == true
      end
      
    end
  end
  
end